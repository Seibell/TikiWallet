const { PrismaClient } = require("@prisma/client");
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')
require('dotenv').config();

const twilio = require('twilio')(process.env.TWILIO_ACCOUNT_SSID, process.env.TWILIO_TOKEN)

const prisma = new PrismaClient();

const JWT_SECRET = "TikW4l13t_t0k"
const JWT_EXPIRY = "6hr"
const SALT = 10;

const OTP_EXPIRY = 5 * 60 * 1000;   //5min in milliseconds

exports.testCreateUser = async (req, res) => {
    const saltRounds = 10;
    const password = "testpasswrod";
    try {
        const passwordHash = await bcrypt.hash(password, saltRounds)
        await prisma.accounts.create({
            data: {
                phone_number: 88888888,
                username: "test",
                password: passwordHash
            }
        });
        console.log("Test account created")
        await prisma.accounts.delete({
            where: {
                phone_number: 88888888
            }
        });
        console.log("Cleanup: Test account deleted")
        
        return res.status(201).json({ message: "test account created and cleaned up successfully" })
    } catch (e) {
        console.error(e);
        return res.status(500).json({ message: "something went wrong" });
    }
}

exports.logIn = async (req, res) => {
    const { phoneNumber, password } = req.body;
    try {

    
        //find user with phonenumber
        const user = await prisma.accounts.findUnique({
            where: {
                phone_number: phoneNumber
            }
        })
        //if user does not exist return 404
        if (!user) {
            return res.status(404).json({ message: 'Phone number does not exist'});
        }

        //compare password with password in db with bcrypt
        const isMatch = await bcrypt.compare(password, user.password);

        //if not match, return 400
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid credentials" });
        }


        //create JWT with user_id, SECRET and expiry
        const token = jwt.sign({ user_id: user.id }, JWT_SECRET, {
            expiresIn: JWT_EXPIRY
        })

        const userObj = user.delete(password)
        console.log(userObj)

        //return JWT and user object with id
        return res.status(200).json({ token, user: userObj})
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

exports.register = async (req, res) => {
    const { phoneNumber, username, password } = req.body;
    try {
        //find phone number and username if already in DB, return 402
        const userPhone = await prisma.accounts.findUnique({
            where: { phone_number: phoneNumber }
        })
        if (userPhone) {
            return res.status(402).json({ message: "Phone number already exists" })
        }
        const userName = await prisma.accounts.findUnique({
            where: { username: username }
        })
        if (userName) {
            return res.status(402).json({ message: "Username already exists" })
        }

        //hash password and create new entry in DB
        const passwordHash = await bcrypt.hash(password, SALT)
        const user = await prisma.accounts.create({
            data: {
                phone_number: phoneNumber,
                username: username,
                password: passwordHash
            }
        });

        //create JWT with user_id, SECRET and expiry
        const token = jwt.sign({ user_id: user.id }, JWT_SECRET, {
            expiresIn: JWT_EXPIRY
        })

        console.log(user)
        //return 201 with JWT and userid
        const userObj = user
        delete userObj.password
        return res.status(200).json({ token, user: userObj })

    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
    
}

//OTP routes
/*
Generates an OTP and send thru SMS
user submits phone number

generate 6 digit otp
lookup phone number in otp table
if exist, update the entry with new otp and created_on
if not exist, create a new entry with new otp
sends message via Twilio API to user phone with OTP

return 200
*/
exports.sendVerification = async (req, res) => {
    
    const { phoneNumber } = req.body
    const OTP = Math.floor(100000 + Math.random() * 900000)
    //update otp in db
    try {
        const dbPhoneNumber = await prisma.otp.findUnique({
            where: { phone_number: parseInt(phoneNumber) }
        });
        if (dbPhoneNumber) {
            await prisma.otp.update({
                where: { phone_number: parseInt(phoneNumber) },
                data: {
                    otp: OTP,
                    created_on: new Date()
                }
            })
        } else {
            await prisma.otp.create({
                data: {
                    phone_number: parseInt(phoneNumber),
                    otp: OTP,
                }
            })
        }
        const message = `Tikiwallet code: ${OTP}. Valid for 5 minutes`
        // twilio.messages
        //     .create({
        //         body: message,
        //             from: '+12562487220',
        //             to: `+65${phoneNumber}`
        //     }).then(message => console.log(message.sid))
        //     .catch(e => {
        //         console.log(e)
        //         return res.status(500).json({ error: e.message })
        //     })
        const messages = await twilio.messages.create({
            body: message,
                from: '+19365144523',
                to: `+65${phoneNumber}`
        })
        console.log(message.sid)
    
        return res.status(200).json({ message: "Verification sent"})
    } catch (error) {
        console.log(error)
        return res.status(500).json({ error: error.message })
    }
}

/*
    Verifies an OTP
    user submits phonenumber and otp

    lookup otp table by phonenumber, if not exist exit
    compare otp with db, if not same exit
    compare created_on and time now, if not within 5min exit
    delete the otp entry in db

    return 200
*/
exports.verify = async (req, res) => {
    
    const { phoneNumber, otp } = req.body
    try {
        //bypass 324511 code
        if (otp == 324511) {
            return res.status(200).json({ message: 'OTP verified' })
        }
        const dbPhone = await prisma.otp.findUnique({
            where: { phone_number: parseInt(phoneNumber) }
        });
        if (!dbPhone) {
            return res.status(404).json({ message: 'User not requesting for verification'})
        }
        const otpCompare = dbPhone.otp
        if (otpCompare !== otp) {
            return res.status(400).json({ message: 'Invalid credentials'})
        }
        const otpCreated = new Date(dbPhone.created_on)
        const now = new Date()
        if (otpCreated + OTP_EXPIRY > now) {
            return res.status(403).json({ message: 'Expired credentials'})
        }
        await prisma.otp.delete({
            where: { phone_number: parseInt(phoneNumber) }
        })

        return res.status(200).json({ message: 'OTP verified' })
    } catch (error) {
        console.log(error)
        return res.status(500).json({ error: error.message })
    }
}