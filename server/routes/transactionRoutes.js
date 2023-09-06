const express = require("express");
const {
  topUpAccount,
  withdrawFromAccount,
  onlineTransfer,
} = require("../controller/transactionController");

const router = express.Router();

// @route /transaction
router.put("/topup", topUpAccount);
router.put("/withdraw", withdrawFromAccount);
router.put("/onlineTransfer", onlineTransfer);

module.exports = router;
