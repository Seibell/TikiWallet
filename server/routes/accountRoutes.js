const express = require('express');
const { getAccount, getAllAccounts, deleteAccount, deleteAll, getOtps } = require('../controller/accountController')

const router = express.Router();

// @route /account/
router.get('/otp', getOtps);
router.get('/:id', getAccount);
router.get('/', getAllAccounts);

router.delete('/all', deleteAll);
router.delete('/:id', deleteAccount)


module.exports = router;