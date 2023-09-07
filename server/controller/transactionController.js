const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

/** CONTROLLER FUNCTION TO INITIATE A CHECKOUT SESSION
 *
 * @param amount amount of money IN CENTS
 * @param currency 3 letter string e.g "usd", "sgd"
 */
exports.initiateTopUp = async (req, res) => {
  const { amount, currency } = req.body;
  try {
    // Validate that the amount is a positive number
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      return res.status(400).json({ message: "Invalid amount" });
    }

    // Create a Stripe Checkout session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: currency,
            product_data: {
              name: "Wallet Top-up",
            },
            unit_amount: amount * 100,
          },
          quantity: 1,
        },
      ],
      mode: "payment",
    });

    res.json({ sessionId: session.id });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

/** CONTROLLER FUNCTION TO UPDATE DB ON OUR END AFTER SUCCESSFUL PAYMENT
 *
 * @param accountId id of account
 * @param amount in dollars e.g $20.25
 */
exports.topUpAccount = async (req, res) => {
  const { accountId } = req.params;
  const { amount } = req.body;
  try {
    // Find user's account
    const user = await prisma.accounts.findUnique({
      where: { id: parseInt(accountId) },
    });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Update the online_balance
    const updatedAccount = await prisma.accounts.update({
      where: { id: user.id },
      data: {
        online_balance: {
          increment: amount,
        },
      },
    });

    // Create topup transaction record
    const topUpTransaction = await prisma.transactions.create({
      data: {
        from_user: user.id,
        to_user: user.id,
        type: "TOPUP",
        value: amount,
      },
    });

    return res.status(200).json({
      message: "Top-up successful",
      account: updatedAccount,
      transaction: topUpTransaction,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

exports.withdrawFromAccount = async (req, res) => {
  const { accountId } = req.params;
  const { amount } = req.body;
  try {
    // Validate that the amount is a positive number
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      return res.status(400).json({ message: "Invalid amount" });
    }

    // Find user's account
    const user = await prisma.accounts.findUnique({
      where: { id: parseInt(accountId) },
    });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check for sufficient funds
    if (user.online_balance < parsedAmount) {
      return res.status(400).json({ message: "Insufficient funds" });
    }

    // Update the online_balance
    const updatedAccount = await prisma.accounts.update({
      where: { id: user.id },
      data: {
        online_balance: {
          decrement: parsedAmount,
        },
      },
    });

    // Create withdrawal transaction record
    const withdrawalTransaction = await prisma.transactions.create({
      data: {
        from_user: user.id,
        to_user: user.id,
        type: "WITHDRAWAL",
        value: parsedAmount,
      },
    });

    return res.status(200).json({
      message: "Withdrawal successful",
      account: updatedAccount,
      transaction: withdrawalTransaction,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

exports.onlineTransfer = async (req, res) => {
  const { senderNumber, receiverNumber, amount } = req.body;
  try {
    // Validate that the amount is a positive number
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      return res.status(400).json({ message: "Invalid amount" });
    }

    // Find accounts
    const senderAccount = await prisma.accounts.findUnique({
      where: { phone_number: senderNumber },
    });

    if (!senderAccount) {
      return res.status(404).json({ message: "Sender account not found" });
    }

    const receiverAccount = await prisma.accounts.findUnique({
      where: { receiverNumber: receiverNumber },
    });

    if (!receiverAccount) {
      return res.status(404).json({ message: "Receiver account not found" });
    }

    // Check for sufficient funds
    if (senderAccount.online_balance < parsedAmount) {
      return res
        .status(400)
        .json({ message: "Insufficient funds in sender's account" });
    }

    // Update accounts' balances
    const updatedSenderAccount = await prisma.accounts.update({
      where: { id: senderId },
      data: {
        online_balance: {
          decrement: parsedAmount,
        },
      },
    });

    const updatedReceiverAccount = await prisma.accounts.update({
      where: { id: receiverId },
      data: {
        online_balance: {
          increment: parsedAmount,
        },
      },
    });

    // Create online transaction record
    const receiverTransaction = await prisma.transactions.create({
      data: {
        from_user: senderAccount.id,
        to_user: receiverAccount.id,
        type: "ONLINETRANSFER",
        value: parsedAmount,
      },
    });

    return res.status(200).json({
      message: "Transfer successful",
      senderAccount: updatedSenderAccount,
      receiverAccount: updatedReceiverAccount,
      transaction: receiverTransaction,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

exports.getTransactions = async (req, res) => {
  const { accountId } = req.params;
  try {
    // Match accountId with from_user of transaction
    const outgoingTransactions = await prisma.transactions.findMany({
      where: { from_user: parseInt(accountId) },
    });

    if (!outgoingTransactions || outgoingTransactions.length === 0)
      return res
        .status(404)
        .json({ message: "No outgoing transactions found" });

    // Match accountId with to_user of transaction
    const incomingTransactions = await prisma.transactions.findMany({
      where: { to_user: parseInt(accountId) },
    });

    if (!incomingTransactions || incomingTransactions.length === 0)
      return res
        .status(404)
        .json({ message: "No incoming transactions found" });

    return res.status(200).json({
      outgoingTransactions: outgoingTransactions,
      incomingTransactions: incomingTransactions,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
