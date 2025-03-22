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
