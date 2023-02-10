const { pool } = require("./../db/dbConfig");
const bcrypt = require('bcrypt');
const sql = require('./../db/sqlQuerries');
const errMsg = require('./errMessages');

const INVALID_INPUT_CODE = 400;
const POST_SUCCESS_CODE = 201;
const GET_SUCCESS_CODE = 200;

//#region  Authentication
module.exports.handlePostUser = async (req, res) => {
   let { email, password, passwordConfirm, firstName, lastName, secondaryLastName, avatarImage, facultyId } = req.body;

   let error_message = '';

   if (!email || !password || !passwordConfirm || !firstName || !lastName || !facultyId) {
      error_message = errMsg.INCOMPLETE_INPUT;
   } else if (password.length < 6) {
      error_message = errMsg.INCORRECT_PASSWORD_FORMAT;
   } else if (password != passwordConfirm) {
      error_message = errMsg.PASSWORDS_NOT_MATCH;
   }

   if (error_message.length != 0) {
      res.send({ body: { message: error_message, status_code: INVALID_INPUT_CODE } });
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

         if (!avatarImage) {
            ///TODO here should be a default avatar
            avatarImage = "null";
         }

         if (!secondaryLastName) {
            ///TODO here should query for partial insertion
            secondaryLastName = "null";
         }

         const userProfileInsertRes = await client.query(sql.USER_PROFILE_INSERT_FULL, [firstName, lastName, secondaryLastName, avatarImage]);
         const profileId = userProfileInsertRes.rows[0].id;

         const roleId = 2; // Student role

         const userInsertRes = await client.query(sql.USER_CENTRALIZED_INSERT, [roleId, credentialsId, profileId, facultyId]);
         const userId = userInsertRes.rows[0].id;

         console.log(`INSERTED user: user_id: ${userId}, role_id = ${roleId}, credentials_id = ${credentialsId}, profile_id = ${profileId}, faculty_id = ${facultyId}`);

         await client.query('COMMIT')
         res.send({ body: { status_code: POST_SUCCESS_CODE, user_id: userId } });


      } catch (e) {
         await client.query('ROLLBACK')
         res.send({ body: { message: e.message, status_code: INVALID_INPUT_CODE } });

         // throw e
      } finally {

         client.release()
      }

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
               res.send({ code: GET_SUCCESS_CODE, id: result.rows[0].id });
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

module.exports.handleGetFaculties = (req, res) => {
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


//#region Product


module.exports.handleGetObjectCategories = (req, res) => {
   pool.query(sql.CATEGORY_READ_ALL, [], (err, result) => {
      if (err) {
         throw err
      }

      let categoriesJson = [];

      for (i = 0; i < result.rows.length; i++) {
         categoriesJson.push({
            id: result.rows[i].id,
            name: result.rows[i].name,
         });
      }

      res.send({ object_categories: categoriesJson });
   });
}

module.exports.handlePostSaleObject = async (req, res) => {
   const title = req.body.title;
   const description = req.body.description;
   const price = req.body.price;
   const ownerID = req.body.ownerID;
   const categoryID = req.body.categoryID;
   const date = req.body.date;

   const client = await pool.connect()

   try {
      await client.query('BEGIN')
      const descriptionRes = await client.query(sql.SALE_OBJECT_DESCRIPTION_INSERT, [title, description, price]);

      const descriptionID = descriptionRes.rows[0].id;
      const objectRes = await client.query(sql.SALE_OBJECT_INSERT, [descriptionID, categoryID, ownerID, date, true]);

      //INSERT IMAGES with descriptionID
      //const photoRes = await client.query(sql.OBJECT_IMAGE_INSERT);

      await client.query('COMMIT')

      res.send({ body: { status_code: POST_SUCCESS_CODE, sale_object_id: objectRes.rows[0].id } });
   } catch (e) {
      await client.query('ROLLBACK')
      res.send({ body: { status_code: INVALID_INPUT_CODE, message: "Invalid input" } });

   } finally {

      client.release()
   }
}

module.exports.handleGetSaleObjectByCategory = async (req, res) => {
   const categoryId = req.body.categoryId;
   const client = await pool.connect()

   try {
      const result = await client.query(sql.SALE_OBJECT_READ_CATEGORY, [categoryId]);
        
      let saleObjectsJson  = [];

      for(i = 0; i<result.rowCount; i++) {
         saleObjectsJson.push({
         title: result.rows[0].title,
         description:  result.rows[0].description,
         price :  result.rows[0].price,
         owner_id :  result.rows[0].owner_id
         });
      }

      res.send({ body: { status_code: GET_SUCCESS_CODE, results: saleObjectsJson } });

   } catch (e) {
      res.send({ body: { status_code: INVALID_INPUT_CODE, message: "Invalid input" } });

      throw e
   } finally {
      client.release()
   }
}

module.exports.handleGetSaleObjectByOwner = async (req, res) => {
   const ownerId = req.body.ownerId;
   const client = await pool.connect()

   try {
      const result = await client.query(sql.SALE_OBJECT_READ_OWNER, [ownerId]);
        
      let saleObjectsJson  = [];

      for(i = 0; i<result.rowCount; i++) {
         saleObjectsJson.push({
         title: result.rows[0].title,
         description:  result.rows[0].description,
         price :  result.rows[0].price,
         category_id :  result.rows[0].category_id
         });
      }

      res.send({ body: { status_code: GET_SUCCESS_CODE, results: saleObjectsJson } });

   } catch (e) {
      res.send({ body: { status_code: INVALID_INPUT_CODE, message: "Invalid input" } });

      throw e
   } finally {
      client.release()
   }
}
//#endregion