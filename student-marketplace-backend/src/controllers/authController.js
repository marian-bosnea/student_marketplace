const { pool } = require("../db/dbConfig");
const bcrypt = require('bcrypt');
const sharp = require('sharp');

const sql = require('../db/sqlQuerries');
const errMsg = require('../constants/errMessages');
const codes = require('../constants/statusCodes');
const authorization = require('../authorization');


registerUser = async (req, res) => {
   let { email, password, passwordConfirm, firstName, lastName, secondaryLastName, avatarImage, facultyId } = req.body;

   console.log(`Registerin user with ${email} : ${password}`)
   let error_message = '';

   if (!email || !password || !passwordConfirm || !firstName || !lastName || !facultyId) {
      error_message = errMsg.INCOMPLETE_INPUT;
   } else if (password.length < 6) {
      error_message = errMsg.INCORRECT_PASSWORD_FORMAT;
   } else if (password != passwordConfirm) {
      error_message = errMsg.PASSWORDS_NOT_MATCH;
   }

   if (error_message.length != 0) {
      res.send({ body: { message: error_message, status_code: codes.INVALID_INPUT_CODE } });
   } else {
      const client = await pool.connect()
      try {
         await client.query('BEGIN')
         const emailCheckRes = await client.query(sql.CREDENTIALS_READ_EMAIL,
            [email]);

         if (emailCheckRes.rows.length > 0) {
            error_message = errMsg.EMAIL_ALREADY_USED;
            throw new Error(error_message);
         }

         const hashedPassword = await bcrypt.hash(password, 10);

         const credentialsInsertRes = await client.query(sql.CREDENTIALS_INSERT, [email, hashedPassword]);
         const credentialsId = credentialsInsertRes.rows[0].id;

         if (!secondaryLastName) {
            ///TODO here should query for partial insertion
            secondaryLastName = "null";
         }

         avatarImage = req.file.path;
         //console.log(req.file);

         const userProfileInsertRes = await client.query(sql.USER_PROFILE_INSERT_FULL, [firstName, lastName, secondaryLastName, avatarImage]);
         const profileId = userProfileInsertRes.rows[0].id;

         const roleId = 2; // Student role

         const userInsertRes = await client.query(sql.USER_CENTRALIZED_INSERT, [roleId, credentialsId, profileId, facultyId]);
         const userId = userInsertRes.rows[0].id;
  
         console.log(`INSERTED user: user_id: ${userId}, role_id = ${roleId}, credentials_id = ${credentialsId}, profile_id = ${profileId}, faculty_id = ${facultyId}`);
         await client.query('COMMIT')

         res.status(codes.POST_SUCCESS_CODE)
         res.send({ userId: userId });


      } catch (e) {
         await client.query('ROLLBACK');
         res.status(codes.INVALID_INPUT_CODE)
         res.send({ message: e.message });

         // throw e
      } finally {
         client.release();
      }
   }
}

uploadProfileAvatar = async (req, res)  => {
const userId = res.locals.decryptedId;
const results = await pool.query(sql.GET_PROFILE_ID, [userId]);
const profileId = results.rows[0].profile_id;
const path  = req.file.path;

await pool.query(sql.UPDATE_PROFILE_AVATAR, [path, profileId]);
res.status(codes.POST_SUCCESS_CODE).send();
}

checkIfEmailExists = (req, res) => {
   const email = req.body.email;

   pool.query(sql.CREDENTIALS_READ_EMAIL, [email], (err, result) => {
      if (err) {
         throw err;
      }

      if (result.rowCount != 0) {
         res.status(codes.POST_SUCCESS_CODE).send();
      } else {
         res.status(codes.INVALID_INPUT_CODE).send();
      }
   });

}

loginUser = (req, res) => {
   const email = req.body.email;
   const password = req.body.password;

   console.log(`[CLIENT][RECEIVED] email: ${email}, password: ${password}`);

   pool.query(sql.CREDENTIALS_READ_EMAIL, [email], (err, result) => {
      if (err) {
         throw err;
      }

      if (result.rows.length > 0) {
         const user = result.rows[0];

         bcrypt.compare(password, user.password, async (err, isMatch) => {
            if (err) {
               throw err
            }

            if (isMatch) {
               const userId = result.rows[0].id;

               const tokens =  authorization.generateAccessToken(userId);
       
               await pool.query(sql.INSERT_TOKEN, [tokens.accessToken]);

               res.status(codes.POST_SUCCESS_CODE);
               res.send({ accessToken: tokens.accessToken, refreshToken: tokens.refreshToken });
            } else {
               res.status(codes.INVALID_INPUT_CODE);
               res.send({ message: errMsg.INCORRECT_PASSWORD });
            }
         });
      } else {
         res.status(codes.INVALID_INPUT_CODE);
         res.send({ message: errMsg.INCORRECT_EMAIL });
      }
   }
   );
}

isUserLoggedIn = (req, res) => {
   const authHeader = req.headers['authorization'];
   const token = authHeader && authHeader.split(' ')[1];

  pool.query(sql.READ_TOKEN, [token], async (err, result) => {
   if(err){
      throw err;
   }

   if(result.rows.length > 0) {
      res.status(codes.GET_SUCCESS_CODE).send();
   } else {
      res.status(codes.UNAUTHORIZED).send({message: 'User logged out'});
   }

  });

}


logoutUser = (req, res) => {
   const authHeader = req.headers['authorization'];
   const token = authHeader && authHeader.split(' ')[1];

  pool.query(sql.READ_TOKEN, [token], async (err, result) => {
   if(err){
      throw err;
   }

   await pool.query(sql.DELETE_TOKEN, [token]);
   res.status(codes.GET_SUCCESS_CODE).send();
  });

}

module.exports = {
   registerUser,
   uploadProfileAvatar,
   checkIfEmailExists,
   loginUser,
   logoutUser,
   isUserLoggedIn
}