const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

exports.getAccount = async (req, res) => {
    const { id } = req.params
    try {
        const user = await prisma.accounts.findUnique({
            where: { id: parseInt(id) }
        })
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        return res.status(200).json(user)
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

exports.getAllAccounts = async (req, res) => {
    try {
        const users = await prisma.accounts.findMany({});
        console.log(users)
        return res.status(200).json(users)
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

exports.deleteAccount = async (req, res) => {
    const { id } = req.params
    try {
        const deleteUser = await prisma.accounts.delete({
            where: { id: parseInt(id) }
        })

        return res.status(200).json(deleteUser)
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

exports.deleteAll = async (req, res) => {
    console.log("WARNING: DELETED ALL ACCOUNTS")
    try {
        const deleteAllAccounts = await prisma.accounts.deleteMany({})

        return res.status(200).json({ message: "Deleted all accounts successfully"})
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

// get all OTP created
exports.getOtps = async (req, res) => {
    try {
        const otps = await prisma.otp.findMany({})
        console.log(otps)
        return res.status(200).json(otps)
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}