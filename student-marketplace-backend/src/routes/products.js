const express = require('express');
const productRouter = express.Router();

const productController = require('../controllers/saleProductController')

productRouter.post('/sale-object/post',
    (req, res) => {
        productController.insert(req, res);
    });

productRouter.get('/sale-object/get/category',
    (req, res) => {
        productController.getAllFromCategory(req, res);
    });

productRouter.get('/sale-object/get/owner',
    (req, res) => {
        productController.getAllByOwnerId(req, res);
    });


module.exports = productRouter;