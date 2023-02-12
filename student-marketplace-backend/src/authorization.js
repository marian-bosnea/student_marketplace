const jwt = require('jsonwebtoken');
const codes = require('./constants/statusCodes');

generateAccessToken = (userId) => {
const accessToken = jwt.sign(userId, process.env.ACCESS_TOKEN_SECRET);
const refreshToken = jwt.sign(userId, process.env.ACCESS_TOKEN_SECRET);

return ({accessToken: accessToken, refreshToken: refreshToken});
}

authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if(token == null) return res.sendStatus(codes.UNAUTHORIZED);

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, userId) => {
       if(err) return res.sendStatus(codes.FORBIDDEN);

       req.userId = userId;
       next();
    });
}

function generateNewAccessToken(userId) {
    return  jwt.sign({ userId: userId }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '15m' });
}

module.exports = {
    generateAccessToken,
    authenticateToken
}