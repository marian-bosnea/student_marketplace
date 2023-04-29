const express = require('express');

const userController = require('../controllers/userController')
const authorization = require('../authorization');

const userRouter = express.Router();

userRouter.post('/user/get/profile',
    authorization.authenticateToken,
    (req, res) => {
        userController.getUserProfile(req, res);
    });

userRouter.post('/user/get/avatar_image',
    authorization.authenticateToken,
    (req, res) => {
        userController.getUserAvatar(req, res);
    });

userRouter.get('/faculties/get/all',
    (req, res) => {
        userController.getAllFaculties(req, res);
    });

module.exports = userRouter;