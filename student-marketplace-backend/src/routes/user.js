const express = require('express');

const userController = require('../controllers/userController')
const authorization = require('../authorization');

const userRouter = express.Router();

userRouter.get('/user/get/profile',
    authorization.authenticateToken,
    (req, res) => {
        userController.getUserProfile(req, res);
    });

userRouter.get('/faculties/get/all',
    (req, res) => {
        userController.getAllFaculties(req, res);
    });

module.exports = userRouter;