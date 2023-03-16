const express = require('express');
const authRouter = express.Router();

const multer = require('multer');
const fs = require('fs');
const path = require('path')
const authorization = require('../authorization');

const authController = require('../controllers/authController')

const avatarPath = `./uploads/users/avatars`;

const storage = multer.diskStorage({
   destination: (req, file, cb) => {
      fs.mkdirSync(avatarPath, { recursive: true })
      cb(null, avatarPath );
   },
   filename: (req, file, cb) => {
      const fileName = Date.now() + path.extname(file.originalname);
       //req.locals.fileName = avatarPath + '/' + fileName;

      cb(null, fileName); //Appending extension
   }
});


const fileFilter =(req, file, cb) => {
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

 authRouter.post('/users/login/local-strategy',
 (req, res) => {
    authController.loginUser(req, res);
 });

 authRouter.get('/users/check-authentication',
 (req, res) => {
   authController.isUserLoggedIn(req, res);
});


 authRouter.get('/users/logout',
 (req, res) => {
    authController.logoutUser(req, res);
 });

 
 authRouter.post('/users/register',upload.single('avatarImage'), async (req, res) => {
    authController.registerUser(req, res);
 });

 authRouter.post('/users/update_avatar',authorization.authenticateToken, upload.single('avatarImage'), async (req, res) => {
   authController.uploadProfileAvatar(req, res);
});
 
 authRouter.post('/users/check-email', async (req, res) => {
    console.log('tried email');
    authController.checkIfEmailExists(req, res);
 });


module.exports = authRouter;