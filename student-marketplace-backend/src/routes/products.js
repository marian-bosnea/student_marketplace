const express = require('express');
const productRouter = express.Router();
const authorization = require('../authorization');

const productController = require('../controllers/saleProductController')

productRouter.post('/sale-object/post',
authorization.authenticateToken,
    (req, res) => {
        productController.insert(req, res);
    });

productRouter.get('/sale-object/get/category',
authorization.authenticateToken,
    (req, res) => {
        productController.getAllFromCategory(req, res);
    });

productRouter.get('/sale-object/get/owner',
authorization.authenticateToken,
    (req, res) => {
        productController.getAllByOwnerId(req, res);
    });


    productRouter.get('/sale-object/get/all',
    authorization.authenticateToken,
        (req, res) => {
            productController.getAll(req, res);
        });
module.exports = productRouter;