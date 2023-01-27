const { pool } = require("./../db/dbConfig");
const bcrypt = require('bcrypt');
const sql = require('./../db/sqlQuerries');
const errMsg = require('./errMessages');

const INVALID_INPUT_CODE = 400;
const POST_SUCCESS_CODE = 201;

//#region  Authentication
module.exports.handleUserRegister = async (req, res) => {
   let { email, password, password_confirm, first_name, last_name, secondary_last_name, avatar_image, faculty_id } = req.body;

   let error_message = '';

   if (!email || !password || !password_confirm || !first_name || !last_name || !faculty_id) {
      error_message = errMsg.INCOMPLETE_INPUT;
   } else if (password.length < 6) {
      error_message = errMsg.INCORRECT_PASSWORD_FORMAT;
   } else if (password != password_confirm) {
      error_message = errMsg.PASSWORDS_NOT_MATCH;
   }

   if (error_message.length != 0) {
      res.send({ body: { message: error_message, status_code: INVALID_INPUT_CODE } });
   } else {
      let hashedPassword = await bcrypt.hash(password, 10);
      pool.query(sql.CREDENTIALS_READ_EMAIL,
         [email],
         (err, results) => {
            if (err) {
               throw err;
            }
            if (results.rows.length > 0) {
               error_message = errMsg.EMAIL_ALREADY_USED;
               res.send({ body: { message: error_message, status_code: INVALID_INPUT_CODE } });
            } else {
               pool.query(sql.CREDENTIALS_INSERT, [email, hashedPassword], (err, result) => {
                  if (err) {
                     throw err;
                  }
               });

               if (!avatar_image) {
                  ///TODO here should be a default avatar
                  avatar_image = "null";
               }

               if (!secondary_last_name) {
                  ///TODO here should query for partial insertion
                  secondary_last_name = "null";
               }

               pool.query(sql.USER_PROFILE_INSERT_FULL, [first_name, last_name, secondary_last_name, avatar_image], (err, result) => {
                  if (err) {
                     throw err;
                  }
                  res.send({ body: { status_code: POST_SUCCESS_CODE } });
               });


            }
         }
      )


   }
}

module.exports.handleUserLogin = (req, res) => {
   const email = req.body.email;
   const password = req.body.password;

   pool.query(sql.CREDENTIALS_READ_EMAIL, [email], (err, result) => {
      if (err) {
         throw err;
      }

      if (result.rows.length > 0) {
         const user = result.rows[0];

         bcrypt.compare(password, user.password, (err, isMatch) => {
            if (err) {
               throw err
            }

            if (isMatch) {
               res.send({ code: POST_SUCCESS_CODE, id: result.rows[0].id });
            } else {
               res.send({ code: INVALID_INPUT_CODE, message: errMsg.INCORRECT_PASSWORD });
            }
         });
      } else {
         res.send({ code: INVALID_INPUT_CODE, message: errMsg.INCORRECT_EMAIL });
      }
   }
   );
}

module.exports.handleFetchAllFaculties = (req, res) => {
   pool.query(sql.FACULTY_READ_ALL, [], (err, result) => {
      if (err) {
         throw err
      }

      let facultiesJson = [];

      for (i = 0; i < result.rows.length; i++) {
         facultiesJson.push({
            id: result.rows[i].id,
            name: result.rows[i].name,
            short_name: result.rows[i].short_name,
            logo_image: result.rows[i].logo_image
         });
      }

      res.send({ faculties: facultiesJson });
   });
}

//#endregion
