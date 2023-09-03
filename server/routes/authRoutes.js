const express = require('express');
const { testCreateUser } = require('../controller/authController')

const router = express.Router();

router.post('/test', testCreateUser);

module.exports = router;