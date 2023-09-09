const express = require("express");
const {
  topUpAccount,
  withdrawFromAccount,
  onlineTransfer,
  initiateTopUp,
  getTransactions,
} = require("../controller/transactionController");

const router = express.Router();

// @route /transaction
router.put("/topup/:accountId ", topUpAccount);
router.put("/withdraw/:accountId ", withdrawFromAccount);
router.put("/onlineTransfer", onlineTransfer);
router.get("/getTransactions/:accountId", getTransactions);
router.post("/initiateTopUp", initiateTopUp);

module.exports = router;
