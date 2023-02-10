const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const server = require('http').createServer(app);
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server: server });

const session = require('express-session');
const requestHandler = require('./req_handling/reqHandler');

const passport = require('passport');
const initializePassport = require('./passportConfig')
initializePassport(passport);



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

// WebSocket
wss.on('connection', (ws) => {
   console.log("Client connected!");
   ws.send("Accepted");

   wss.on('message', (message) => {
      console.log(`Received ${message}`);
   });

});

//#region ROUTES

app.get('/', (req, res) => res.send("Connected to server!"));

//#region Authentication
app.post('/users/register', async (req, res) => {
   requestHandler.handlePostUser(req, res);
});

app.get('/users/login/local_strategy',
   (req, res) => {
      requestHandler.handleUserLogin(req, res);
   });


//#endregion

//#endregion

app.get('/faculties/fetch-all',
   (req, res) => {
      requestHandler.handleGetFaculties(req, res);
   });

app.post('/sale-object/post',
   (req, res) => {
      requestHandler.handlePostSaleObject(req, res);
   });

/// Main loop
server.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
}
);