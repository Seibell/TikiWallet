const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// TODO: Implement stripe API

exports.topUpAccount = async (req, res) => {
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

    // Update the online_balance
    const updatedAccount = await prisma.accounts.update({
      where: { id: user.id },
      data: {
        online_balance: {
          increment: parsedAmount,
        },
      },
    });

    // Create topup transaction record
    /** TODO: Add code for creating transaction (after finalising schema) */

    return res
      .status(200)
      .json({ message: "Top-up successful", updatedAccount });
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
    /** TODO: Add code for creating transaction (after finalising schema) */

    return res
      .status(200)
      .json({ message: "Withdrawal successful", updatedAccount });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

exports.onlineTransfer = async (req, res) => {
  const { senderId, receiverId, amount } = req.body;
  try {
    // Validate that the amount is a positive number
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      return res.status(400).json({ message: "Invalid amount" });
    }

    // Find accounts
    const senderAccount = await prisma.accounts.findUnique({
      where: { id: senderId },
    });

    if (!senderAccount) {
      return res.status(404).json({ message: "Sender account not found" });
    }

    const receiverAccount = await prisma.accounts.findUnique({
      where: { id: receiverId },
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

    // Create online transaction records
    /** TODO: Add creation of transaction */

    return res.status(200).json({
      message: "Transfer successful",
      senderAccount: updatedSenderAccount,
      receiverAccount: updatedReceiverAccount,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
