const express = require('express');
const orderRouter = express.Router();
const orderController = require('../controllers/ordersController')
const authorization = require('../authorization');

orderRouter.post('/order/insert',
    authorization.authenticateToken,
    (req, res) => {
        orderController.insert(req, res);
    });

orderRouter.post('/order/read/buyer',
    authorization.authenticateToken,
    (req, res) => {
        orderController.readByBuyer(req, res);
    });

orderRouter.post('/order/read/seller',
    authorization.authenticateToken,
    (req, res) => {
        orderController.readBySeller(req, res);
    });

orderRouter.post('/order/update',
    authorization.authenticateToken,
    (req, res) => {
        orderController.update(req, res);
    });


orderRouter.post('/order/delete',
    authorization.authenticateToken,
    (req, res) => {
        orderController.remove(req, res);
    });



module.exports = orderRouter;