const express = require('express');
const { PrismaClient } = require('@prisma/client');
const cors = require('cors')
const PORT = process.env.PORT || 3000;

const authRoutes = require('./routes/authRoutes')
const transactionRoutes = require('./routes/transactionRoutes')
const accountRoutes = require('./routes/accountRoutes')

const app = express();

app.use(
    cors({
      origin: "*",
      methods: ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"],
      allowedHeaders: ["Content-Type", "Authorization"],
      optionsSuccessStatus: 200,
    })
  );
app.use(express.json());
app.use('/auth', authRoutes);
app.use('/transaction', transactionRoutes);
app.use('/account', accountRoutes);


const startServer = async () => {
    const prisma = new PrismaClient();
    try {
        await prisma.$connect();
        app.listen(PORT, () => {
            console.log(`Server is running on http://localhost:${PORT}`);
        });
        app.get('/', (req, res) => { res.send('Express server is up'); });

    } catch (error) {
        console.log(error);
        process.exit(1);
    } finally {
        await prisma.$disconnect();
    }
}

startServer()
