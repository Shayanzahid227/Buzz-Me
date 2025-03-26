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
const stripe = require("stripe")("sk_test_51Lxl0OLy0LoiWOlnUD6hTUGXbyYHfe1JVk3kMOMtu4xR5fY52UDxEPC9aJnRZ9GM3wBRD2X5Jtt8IiXiNpksgzkF00WpLMRVTX"); // Replace with your Stripe secret key
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

// // Create subscription
// exports.createSubscription = functions.https.onRequest(async (req, res) => {
//   // Enable CORS
//   res.set('Access-Control-Allow-Origin', '*');
//   res.set('Access-Control-Allow-Methods', 'POST');
//   res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

//   // Handle preflight requests
//   if (req.method === 'OPTIONS') {
//     res.status(204).send('');
//     return;
//   }

//   try {
//     // Verify Firebase Auth token
//     const authHeader = req.headers.authorization;
//     if (!authHeader || !authHeader.startsWith('Bearer ')) {
//       throw new Error('No authorization token provided');
//     }

//     const idToken = authHeader.split('Bearer ')[1];
//     const decodedToken = await admin.auth().verifyIdToken(idToken);
//     const userId = decodedToken.uid;

//     // Get request body
//     const { paymentMethodId, amount, interval } = req.body;

//     // Create or get Stripe customer
//     const userDoc = await admin.firestore().collection('users').doc(userId).get();
//     const userData = userDoc.data();
//     let customerId = userData?.stripeCustomerId;

//     if (!customerId) {
//       // Create new Stripe customer
//       const customer = await stripe.customers.create({
//         email: decodedToken.email,
//         metadata: {
//           firebaseUID: userId
//         }
//       });
//       customerId = customer.id;

//       // Save Stripe customer ID to Firestore
//       await admin.firestore().collection('users').doc(userId).update({
//         stripeCustomerId: customerId
//       });
//     }

//     // Attach payment method to customer
//     await stripe.paymentMethods.attach(paymentMethodId, {
//       customer: customerId
//     });

//     // Set as default payment method
//     await stripe.customers.update(customerId, {
//       invoice_settings: {
//         default_payment_method: paymentMethodId
//       }
//     });

//     // Create subscription
//     const subscription = await stripe.subscriptions.create({
//       customer: customerId,
//       items: [{
//         price_data: {
//           currency: 'usd',
//           product_data: {
//             name: 'Buzz Me VIP Subscription',
//           },
//           unit_amount: amount,
//           recurring: {
//             interval: interval === '2 months' ? 'month' : interval,
//             interval_count: interval === '2 months' ? 2 : 1,
//           },
//         },
//       }],
//       payment_behavior: 'default_incomplete',
//       payment_settings: { save_default_payment_method: 'on_subscription' },
//       expand: ['latest_invoice.payment_intent'],
//     });

//     // Return subscription data
//     res.json({
//       id: subscription.id,
//       status: subscription.status,
//       currentPeriodEnd: subscription.current_period_end,
//       clientSecret: subscription.latest_invoice.payment_intent.client_secret
//     });

//   } catch (error) {
//     console.error('Error creating subscription:', error);
//     res.status(400).json({
//       error: error.message
//     });
//   }
// });

// // Cancel subscription
// exports.cancelSubscription = functions.https.onRequest(async (req, res) => {
//   // Enable CORS
//   res.set('Access-Control-Allow-Origin', '*');
//   res.set('Access-Control-Allow-Methods', 'POST');
//   res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

//   // Handle preflight requests
//   if (req.method === 'OPTIONS') {
//     res.status(204).send('');
//     return;
//   }

//   try {
//     // Verify Firebase Auth token
//     const authHeader = req.headers.authorization;
//     if (!authHeader || !authHeader.startsWith('Bearer ')) {
//       throw new Error('No authorization token provided');
//     }

//     const idToken = authHeader.split('Bearer ')[1];
//     await admin.auth().verifyIdToken(idToken);

//     // Get subscription ID from request
//     const { subscriptionId } = req.body;

//     // Cancel subscription at period end
//     const subscription = await stripe.subscriptions.update(subscriptionId, {
//       cancel_at_period_end: true
//     });

//     res.json({
//       id: subscription.id,
//       status: subscription.status,
//       currentPeriodEnd: subscription.current_period_end
//     });

//   } catch (error) {
//     console.error('Error cancelling subscription:', error);
//     res.status(400).json({
//       error: error.message
//     });
//   }
// });

// // Webhook to handle subscription events
// exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
//   const sig = req.headers['stripe-signature'];
//   const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET;

//   let event;

//   try {
//     event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
//   } catch (err) {
//     console.error('Webhook signature verification failed:', err.message);
//     return res.status(400).send(`Webhook Error: ${err.message}`);
//   }

//   try {
//     switch (event.type) {
//       case 'customer.subscription.updated':
//         const subscription = event.data.object;
//         const customerId = subscription.customer;

//         // Get user document by Stripe customer ID
//         const userSnapshot = await admin.firestore()
//           .collection('users')
//           .where('stripeCustomerId', '==', customerId)
//           .limit(1)
//           .get();

//         if (!userSnapshot.empty) {
//           const userDoc = userSnapshot.docs[0];
//           const updates = {
//             subscriptionId: subscription.id,
//             subscriptionStatus: subscription.status,
//             vipEndDate: new Date(subscription.current_period_end * 1000),
//             isVip: subscription.status === 'active'
//           };

//           await userDoc.ref.update(updates);
//         }
//         break;

//       case 'customer.subscription.deleted':
//         const deletedSubscription = event.data.object;
//         const deletedCustomerId = deletedSubscription.customer;

//         // Get user document by Stripe customer ID
//         const deletedUserSnapshot = await admin.firestore()
//           .collection('users')
//           .where('stripeCustomerId', '==', deletedCustomerId)
//           .limit(1)
//           .get();

//         if (!deletedUserSnapshot.empty) {
//           const deletedUserDoc = deletedUserSnapshot.docs[0];
//           await deletedUserDoc.ref.update({
//             subscriptionStatus: 'cancelled',
//             vipEndDate: new Date(),
//             isVip: false
//           });
//         }
//         break;
//     }

//     res.json({ received: true });
//   } catch (error) {
//     console.error('Error processing webhook:', error);
//     res.status(500).json({ error: error.message });
//   }
// });
