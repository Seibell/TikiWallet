const express = require('express');
const { testCreateUser, logIn, register, sendVerification, verify } = require('../controller/authController')

const router = express.Router();

// @route /auth
router.post('/test', testCreateUser);
router.post('/login', logIn);
router.post('/register', register);

//OTP routes
router.post('/generate-otp', sendVerification);
router.post('/verify-otp', verify);


module.exports = router;