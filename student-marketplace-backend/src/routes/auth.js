const express = require('express');
const authRouter = express.Router();

const authController = require('../controllers/authController')

authRouter.post('/users/register', async (req, res) => {
    authController.registerUser(req, res);
 });

 authRouter.post('/users/login/local-strategy',
 (req, res) => {
    authController.loginUser(req, res);
 });

 authRouter.post('/users/register', async (req, res) => {
    authController.registerUser(req, res);
 });
 
 authRouter.post('/users/check-email', async (req, res) => {
    authController.checkIfEmailExists(req, res);
 });
 
 
module.exports = authRouter;