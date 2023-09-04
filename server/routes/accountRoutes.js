const express = require('express');
const { getAccount, getAllAccounts, deleteAccount, deleteAll } = require('../controller/accountController')

const router = express.Router();

router.get('/:id', getAccount);
router.get('/', getAllAccounts);

router.delete('/all', deleteAll);
router.delete('/:id', deleteAccount)


module.exports = router;