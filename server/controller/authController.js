const { PrismaClient } = require("@prisma/client");
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')
const prisma = new PrismaClient();

const JWT_SECRET = "TikW4l13t_t0k"
const JWT_EXPIRY = "6hr"
const SALT = 10;

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