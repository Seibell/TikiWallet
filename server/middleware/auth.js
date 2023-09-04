const jwt = require('jsonwebtoken');
const SECRET = "TikW4l13t_t0k"

const verifyToken = async (req, res, next) => {
    try {
        let token = req.header("Authorization");

        if (!token) {
            return res.status(401).send("Access Denied");
        }

        if (token.startsWith("Bearer ")){
            token = token.slice(7, token.length).trimLeft();
        }

        const verified = jwt.verify(token, SECRET);
        const userId = verified.user_id

        if (req.body.user_id && req.body.user_id !== userId) {
            res.status(401).json({ message: 'Invalid user ID' });
        } else {
            next();
        }

    } catch (error) {
        res.status(401).json({ error: error.message });
    }
}

module.exports = verifyToken