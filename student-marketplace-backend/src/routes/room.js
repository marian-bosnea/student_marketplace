const express = require('express');
const roomRouter = express.Router();
const roomController = require('../controllers/roomController')
const authorization = require('../authorization');

roomRouter.post('/rooms/read',
    authorization.authenticateToken,
    (req, res) => {
        roomController.read(req, res);
    });


module.exports = roomRouter;