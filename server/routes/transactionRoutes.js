const express = require("express");
const {
  topUpAccount,
  withdrawFromAccount,
  onlineTransfer,
  getTransactions,
} = require("../controller/transactionController");

const router = express.Router();

// @route /transaction
router.put("/topup/:accountId ", topUpAccount);
router.put("/withdraw/:accountId ", withdrawFromAccount);
router.put("/onlineTransfer", onlineTransfer);
router.get("/getTransactions/:accountId", getTransactions);

module.exports = router;
