const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const server = require('http').createServer(app);
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server: server });

const session = require('express-session');
const passport = require('passport');
const initializePassport = require('./passportConfig')
initializePassport(passport);

// For production
//app.use(express.urlencoded({extended: false}));
const bodyParser = require('body-parser');

const authRouter = require('./routes/auth');
const productRouter = require('./routes/products');
const userRouter = require('./routes/user')

// Middleware
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

app.use(authRouter);
app.use(productRouter);
app.use(userRouter);

// WebSocket
wss.on('connection', (ws) => {
   console.log("Client connected!");
   ws.send("Accepted");

   wss.on('message', (message) => {
      console.log(`Received ${message}`);
   });

});

app.get('/', (req, res) => res.send("Connected to server!"));

server.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
}
);


