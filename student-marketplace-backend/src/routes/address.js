const express = require('express');
const addressRouter = express.Router();
const addressController = require('../controllers/addressController')
const authorization = require('../authorization');

addressRouter.post('/address/insert',
    authorization.authenticateToken,
    (req, res) => {
        addressController.insert(req, res);
    });

addressRouter.post('/address/read',
    authorization.authenticateToken,
    (req, res) => {
        addressController.read(req, res);
    });

addressRouter.post('/address/update',
    authorization.authenticateToken,
    (req, res) => {
        addressController.update(req, res);
    });


addressRouter.post('/address/delete',
    authorization.authenticateToken,
    (req, res) => {
        addressController.remove(req, res);
    });



module.exports = addressRouter;