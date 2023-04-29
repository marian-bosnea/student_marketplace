const express = require('express');
const productRouter = express.Router();
const authorization = require('../authorization');
const multer = require('multer');
const productController = require('../controllers/saleProductController')
const fs = require('fs');
const path = require('path')
const salePostsPath = `./uploads/users/sale_posts`;

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        fs.mkdirSync(salePostsPath, { recursive: true })
        cb(null, salePostsPath);
    },
    filename: (req, file, cb) => {
        const fileName = Date.now() + path.extname(file.originalname);
        //req.locals.fileName = avatarPath + '/' + fileName;

        cb(null, fileName); //Appending extension
    }
});


const fileFilter = (req, file, cb) => {
    if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
        return cb(new Error('Please upload a valid image file'))
    }
    cb(undefined, true);
};

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 5
    },
    fileFilter: fileFilter
});

productRouter.post('/sale-object/post',
    authorization.authenticateToken,
    upload.array('images', 4),
    (req, res) => {
        productController.insert(req, res);
    });

productRouter.post('/sale-object/update',
    authorization.authenticateToken,
    upload.array('images', 4),
    (req, res) => {
        productController.update(req, res);
    });

productRouter.post('/sale-object/get/category',
    authorization.authenticateToken,
    (req, res) => {
        productController.getAllFromCategory(req, res);
    });

productRouter.post('/sale-object/get/owner',
    authorization.authenticateToken,
    (req, res) => {
        productController.getAllByOwnerId(req, res);
    });


productRouter.get('/sale-object/get/all',
    authorization.authenticateToken,
    (req, res) => {
        productController.getAll(req, res);
    });

productRouter.post('/sale-object/get/query',
    authorization.authenticateToken,
    (req, res) => {
        console.log('Requested posts by query');
        productController.searchWithTextQuery(req, res);
    });

productRouter.post('/sale-object/get/detailed',
    authorization.authenticateToken,
    (req, res) => {
        productController.getDetailedSalePost(req, res);
    });

productRouter.post('/sale-object/favorites/add',
    authorization.authenticateToken,
    (req, res) => {
        productController.addToFavorites(req, res);
    });

productRouter.post('/sale-object/favorites/read-all',
    authorization.authenticateToken,
    (req, res) => {
        productController.readAllFavorites(req, res);
    });

productRouter.post('/sale-object/favorites/remove',
    authorization.authenticateToken,
    (req, res) => {
        productController.removeFromFavorites(req, res);
    });

productRouter.post('/sale-object/favorites/check',
    authorization.authenticateToken,
    (req, res) => {
        productController.checkIfFavorite(req, res);
    });

productRouter.get('/product-categories/get/all',
    authorization.authenticateToken,
    (req, res) => {
        productController.getCategories(req, res);
    });


productRouter.post('/sale-object/get/image',
    authorization.authenticateToken,
    (req, res) => {
        productController.getImage(req, res);
    });

module.exports = productRouter;