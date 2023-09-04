const express = require('express');
const { testCreateUser, logIn, register } = require('../controller/authController')

const router = express.Router();

router.post('/test', testCreateUser);
router.post('/login', logIn);
router.post('/register', register);

//OTP routes

module.exports = router;