const { PrismaClient } = require("@prisma/client");
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

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