const express = require('express')
const app = express();
const port = 3000;

const { Client } = require('pg');

const client = new Client({
   user: 'postgres',
   host: 'localhost',
   database: 'student-marketplace-db',
   password: 'haarpcord2233',
   port: 5432,
});

client.connect();

client.query("SELECT * FROM user_role").then(res => {
 console.log(res);
 
})
.catch(err => {
      console.error(err);
   })
.finally(() => {
      client.end();
   });


// app.get("/student", (req, res) => {
//    res.send("Hello client!");
// });

// app.listen(port, () => console.log('app listening to port ${port}'));