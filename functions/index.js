/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const stripe = require("stripe")("sk_live_gSNMEgnph76aYVgDPeEoosiz"); // Replace with your Stripe secret key
const { RtcTokenBuilder, RtmTokenBuilder, RtcRole } = require('agora-access-token');
const functions = require('firebase-functions');


// Initialize Firebase Admin
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });




exports.createAccountLink = onRequest(async(req, res) => {
  try {
    const { account } = req.body;

    const accountLink = await stripe.accountLinks.create({
      account: account,
      return_url: `${req.headers.origin}/return/${account}`,
      refresh_url: `${req.headers.origin}/refresh/${account}`,
      type: "account_onboarding",
    });

    res.json(accountLink);
  } catch (error) {
    console.error(
      "An error occurred when calling the Stripe API to create an account link:",
      error
    );
    res.status(500);
    res.send({ error: error.message });
  }
});

exports.createAccount = onRequest(async (req, res) => {
  try {
    const account = await stripe.accounts.create({
      controller: {
        stripe_dashboard: {
          type: "none",
        },
        fees: {
          payer: "application"
        },
        losses: {
          payments: "application"
        },
        requirement_collection: "application",
      },
      capabilities: {
        transfers: {requested: true}
      },
      country: "DE",
    });

    res.json({
      account: account.id,
    });
  } catch (error) {
    console.error(
      "An error occurred when calling the Stripe API to create an account",
      error
    );
    res.status(500);
    res.send({ error: error.message });
  }
});


// Create payment intent endpoint
exports.createCheckoutSession = onRequest(async (request, response) => {
  // Enable CORS
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "POST");
  response.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight requests
  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  try {
    // Verify Firebase Auth token
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new Error("No authorization token provided");
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    // Get request body
    const { amount, currency, connected_account_id } = request.body;

    // Validate required fields
    if (!amount || !currency) {
      throw new Error("Amount and currency are required");
    }

    const session = await stripe.checkout.sessions.create({
      line_items: [
        {
          price_data: {
            currency: currency.toLowerCase(),
            product_data: {
              name: 'Call-Minutes',
            },
            unit_amount: parseInt(amount),
          },
          quantity: 1,
        },
      ],
      payment_intent_data: {
        application_fee_amount: parseInt((amount*0.1)),
        on_behalf_of: connected_account_id,
        transfer_data: {
          destination: connected_account_id,
        },
      },
      mode: 'payment',
      success_url: 'https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
    });

    // Return the client secret and payment intent ID
    response.json({
      link: session.url,
  
    });
  } catch (error) {
    logger.error("Error creating payment intent:", error);
    response.status(400).json({
      error: error.message,
    });
  }
});




// Create payment intent endpoint
exports.createPaymentIntent = onRequest(async (request, response) => {
  // Enable CORS
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "POST");
  response.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight requests
  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  try {
    // Verify Firebase Auth token
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new Error("No authorization token provided");
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    // Get request body
    const { amount, currency, description, metadata } = request.body;

    // Validate required fields
    if (!amount || !currency) {
      throw new Error("Amount and currency are required");
    }

    // Create payment intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(amount),
      currency: currency.toLowerCase(),
      description: description || "Payment for Buzz Me call minutes",
      metadata: {
        ...metadata,
        userId: userId,
      },
      automatic_payment_methods: {
        enabled: true,
      },
    });

    // Return the client secret and payment intent ID
    response.json({
      id: paymentIntent.id,
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    logger.error("Error creating payment intent:", error);
    response.status(400).json({
      error: error.message,
    });
  }
});

// Your Agora App ID and App Certificate (you'll need to get these from your Agora Console)
const appId = process.env.AGORA_APP_ID;
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

// Token generation endpoint
exports.generateToken = onRequest(async (request, response) => {
  // Enable CORS
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  response.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight requests
  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  try {
    // Verify Firebase Auth token
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new Error("No authorization token provided");
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    // Get request parameters
    const channelName = request.body.channelName;
    const uid = request.body.uid || 0; // If not specified, use 0
    const account = request.body.account || ""; // For RTM token

    if (!channelName) {
      throw new Error("Channel name is required");
    }

    // Calculate privilege expire time
    const role = RtcRole.PUBLISHER;
    const expirationTimeInSeconds = 3600; // 1 hour
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    // Generate RTC token
    const rtcToken = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpiredTs
    );

    // Generate RTM token
    const rtmToken = RtmTokenBuilder.buildToken(
      appId,
      appCertificate,
      account || userId, // Use userId as account if not specified
      privilegeExpiredTs
    );

    // Return both tokens
    response.json({
      rtcToken,
      rtmToken,
      uid: uid,
      channel: channelName,
      expiresIn: expirationTimeInSeconds
    });

  } catch (error) {
    logger.error("Error generating token:", error);
    response.status(400).json({
      error: error.message
    });
  }
});
