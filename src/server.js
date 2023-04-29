const express = require('express');
require("dotenv").config({path: '../.env'});
const app = express();
const PORT = process.env.PORT || 3000;


const server = require('http').createServer(app);
const io = require('socket.io')(server);
//const wss = new WebSocket.Server({ server: server });

const session = require('express-session');
const passport = require('passport');
const initializePassport = require('./passportConfig')
initializePassport(passport);

// For production
//app.use(express.urlencoded({extended: false}));
const bodyParser = require('body-parser');

const authRouter = require('./routes/auth');
const productRouter = require('./routes/products');
const userRouter = require('./routes/user');
const addressRouter = require('./routes/address');
const orderRouter = require('./routes/orders');
const roomRouter = require('./routes/room');

const roomController = require('./controllers/roomController');
const messageController = require('./controllers/messagesController');

const authorization = require('./authorization');
const { MESSAGE_INSERT } = require('./db/sqlQuerries');

// Middleware
app.use(bodyParser.urlencoded({
   extended: true,
   limit: '200mb'
}));

app.use(bodyParser.json({ limit: '200mb' }));

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
app.use(addressRouter);
app.use(orderRouter);
app.use(roomRouter); 

// WebSocket
io.on('connection', (socket) => {
   // Authenticate the socket connection
   const token = socket.handshake.query.token;
   const userId = authorization.getId(token);

   if (!userId) {
      //Reject the connection
      socket.emit('unauthorized', { message: 'Invalid token' });
      socket.disconnect(true);
      return;
   }

   console.log(`User with id = ${userId} connected via socket`);


   socket.on('join-room', async (message, cb) => {
      // Fetch messages from the database based on room ID

      const partnerId = message.partnerId;
      if (userId == partnerId) return;
      var roomId = await roomController.checkIfExists(userId, partnerId);

      if (!roomId) {
         roomId = await roomController.insert(userId, partnerId, '', '');
      }

      console.log(`User #${userId} joined chat  with #${partnerId} on room #${roomId}`);

      socket.join(roomId);
      socket.emit('joined-room', roomId);

      const messages = await messageController.read(roomId);
      const messageToSend = [];
      for (i = 0; i < messages.length; i++) {
         const msg = messages[i];
         var senderName = msg.sender_name;
         if (msg.sender_id == userId) {
            senderName = 'You';
         }
         messageToSend.push({
            content: msg.content,
            sender_id: msg.sender_id,
            sender_name: senderName,
            time: msg.time
         });
      }
      socket.emit('prev-messages', messageToSend);
   })

   socket.on('send-message', async message => {
      const roomId = message.roomId;
      const content = message.content;

      console.log(message.roomId);

      const date_time = new Date();
      const hours = date_time.getHours();
      const minutes = date_time.getMinutes();
      const time = `${hours}:${minutes}`

      await messageController.insert(roomId, content, time, userId);
      roomController.update(content, time, roomId);

      io.to(roomId).emit('receive-message', {
         content: content,
         time: time,
         sender_id: userId,
         sender_name: 'hardcoded name'
      });
   })

   socket.on('close', function () {
      console.log('User Disconnected: ' + userID)
   })

   socket.send('connected'); //innitial connection return message
});


app.get('/', (req, res) => res.send("Connected to server!"));

server.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
}
);


