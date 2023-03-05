const { pool } = require("../db/dbConfig");
const sql = require('../db/sqlQuerries');

const codes = require('../constants/statusCodes');
var path = require('path');

getAllFaculties = (req, res) => {
    pool.query(sql.FACULTY_READ_ALL, [], (err, result) => {
       if (err) {
          throw err
       }
 
       let facultiesJson = [];
 
       for (i = 0; i < result.rows.length; i++) {
          facultiesJson.push({
             id: result.rows[i].id,
             name: result.rows[i].name,
             shortName: result.rows[i].short_name,
             logoImage: result.rows[i].logo_image
          });
       }
 
       res.status(codes.GET_SUCCESS_CODE);
       res.send({ faculties: facultiesJson });
    });
 }
 
getUserProfile = async (req, res) => {
    const userId = req.userId;
    const client = await pool.connect()

    try {
       const result = await client.query(sql.USER_PROFILE_READ, [userId]);
 
       const profileJson = {
          firstName: result.rows[0].first_name,
          lastName: result.rows[0].last_name,
          secondaryLastName: result.rows[0].secondary_last_name,
          //avatarImage: result.rows[0].avatar_image,
          facultyName: result.rows[0].faculty_name
       }
       const fileSrc = result.rows[0].avatar_image;
       const filePath = path.resolve(__dirname + '../../../' +  fileSrc);
       res.sendFile(filePath);
       res.status(codes.GET_SUCCESS_CODE);
       
       res.send(profileJson);
 
    } catch (e) {
       res.status(codes.INVALID_INPUT_CODE);
       res.send({ message: "Invalid input"});
       throw e
       
    } finally {
       client.release()
    }
 }

  
getUserAvatar = async (req, res) => {
  const userId = res.locals.decryptedId;

   const client = await pool.connect()

   try {
      const results = await client.query(sql.GET_USER_AVATAR, [userId]);
      const fileSrc = results.rows[0].avatar_image;

      const filePath = path.resolve(__dirname + '../../../' +  fileSrc);
      res.sendFile(filePath);
      res.status(codes.GET_SUCCESS_CODE);

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input"});
      throw e
      
   } finally {
      client.release()
   }

}
 

 module.exports = {
    getAllFaculties,
    getUserProfile,
    getUserAvatar
 }