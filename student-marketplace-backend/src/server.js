const express = require('express');
const app = express();

const session = require('express-session');
const requestHandler = require('./req_handling/reqHandler');

const passport = require('passport');
const initializePassport = require('./passportConfig')
initializePassport(passport);

/// Constants
const PORT = process.env.PORT || 3000;

// For production
//app.use(express.urlencoded({extended: false}));

// For Postman testing purposes
const bodyParser = require('body-parser');

/// App uses
app.use(bodyParser.urlencoded({
   extended: true
}));
app.use(bodyParser.json());

app.use(session({
   secret: 'secret',
   resave: false,
   saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session());


//#region HTTPS Requests

//#region Authentication

app.post('/users/register', async (req, res) => {
   requestHandler.handleUserRegister(req, res);
});

app.post('/users/login/local_strategy',
   (req, res) => {
      requestHandler.handleUserLogin(req, res);
   });

app.post('/faculties/fetch',
   (req, res) => {
      requestHandler.handleFetchAllFaculties(req, res);
   });
//#endregion

//#endregion

/// Main loop
app.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
}
);