const functions = require("firebase-functions");
const Razorpay = require("razorpay");
const cors = require("cors")({ origin: true });

const razorpay = new Razorpay({
  key_id: functions.config().razorpay.key,
  key_secret: functions.config().razorpay.secret,
});

exports.createRazorpayOrder = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const { amount, currency = "INR", receipt } = req.body;

    if (!amount || !receipt) {
      return res.status(400).json({ error: "Amount and receipt are required." });
    }

    try {
      const order = await razorpay.orders.create({
        amount: amount * 100, // Razorpay expects amount in paise
        currency,
        receipt,
      });

      return res.status(200).json(order);
    } catch (error) {
      console.error("Error creating Razorpay order", error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  });
});
