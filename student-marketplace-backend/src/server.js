/// Modules
const express = require('express');
const { pool } = require("./dbConfig");
const bcrypt = require('bcrypt');
const passport = require('passport');
const initializePassport = require('./passportConfig')

const app = express();

initializePassport(passport);

/// Constants
const PORT = process.env.PORT || 3000;
const INVALID_INPUT_CODE = 400;
const POST_SUCCESS_CODE = 201;

// For production
//app.use(express.urlencoded({extended: false}));

// For Postman testing purposes
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({
   extended: true
}));
app.use(bodyParser.json());


app.use(passport.session);
app.use(passport.initialize);

app.post("/users/register", async (req, res) => {
   let { email, password, password_confirm } = req.body;

   let error_message = "";

   if (!email || !password || !password_confirm) {
      error_message = "All fields must be filled.";
   } else if (password.length < 6) {
      error_message = "Password must be at least 6 characters long.";
   } else if (password != password_confirm) {
      error_message = "Entered passwords do not match.";
   }

   if (error_message.length != 0) {
      res.send({ body: { message: error_message, status_code: INVALID_INPUT_CODE } });
   } else {
      let hashedPassword = await bcrypt.hash(password, 10);
      const query = 'SELECT * FROM authentication_credentials where email = $1';

      pool.query(query,
         [email],
         (err, results) => {
            if (err) {
               throw err
            }
            if (results.rows.length > 0) {
               error_message = "Email is associated with other account.";
               res.send({ body: { message: error_message, status_code: INVALID_INPUT_CODE } });
            } else {
               res.send({ body: { status_code: POST_SUCCESS_CODE } });
            }
         }
      )
   }
});

app.post('/users/login'), passport.authenticate('local', {
   function (req, res) {
      res.send("Successfuly logged in!");
   }
});

// Listen to specified port
app.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
}

);