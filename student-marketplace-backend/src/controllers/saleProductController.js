const { pool } = require("../db/dbConfig");
const sql = require('../db/sqlQuerries');

const codes = require('../constants/statusCodes');
var path = require('path');

getCategories = (req, res) => {
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

      res.status(codes.GET_SUCCESS_CODE);
      res.send({ object_categories: categoriesJson });
   });
}

insert = async (req, res) => {
   const title = req.body.title;
   const description = req.body.description;
   const price = req.body.price;
   const ownerID = res.locals.decryptedId;
   const categoryID = req.body.categoryId;
   const date = req.body.date;

   const client = await pool.connect()

   try {
      await client.query('BEGIN')
      const descriptionRes = await client.query(sql.SALE_OBJECT_DESCRIPTION_INSERT, [title, description, price]);

      const descriptionID = descriptionRes.rows[0].id;
      const objectRes = await client.query(sql.SALE_OBJECT_INSERT, [descriptionID, categoryID, ownerID, date, true]);

      var paths = req.files.map(file => file.path)

      for (var p in paths) {
         console.log(paths[p]);
         const photoRes = await client.query(sql.OBJECT_IMAGE_INSERT, [paths[p], descriptionID]);
      }

      await client.query('COMMIT')

      res.status(codes.POST_SUCCESS_CODE);
      res.send({ id: objectRes.rows[0].id });

   } catch (e) {
      console.log(e);

      await client.query('ROLLBACK');
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

   } finally {

      client.release()
   }
}

getAll = async (req, res) => {
   console.log("Requested all sale posts");
   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_ALL);
      let saleObjectsJson = [];
   
      for (i = 0; i < results.rowCount; i++) {
         saleObjectsJson.push({
            id: results.rows[i].id,
            title: results.rows[i].title,
            description: results.rows[i].description,
            price: results.rows[i].price,
            date: results.rows[i].date,
            category_id : 1,
            owner_id: results.rows[i].owner_id,
            owner_name: results.rows[i].owner_name
         });
      }
      
      res.status(codes.GET_SUCCESS_CODE);
      res.send({results: saleObjectsJson});
   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({message: "Invalid input"});
      throw e
   } finally {
      client.release()

   }


}

getAllFromCategory = async (req, res) => {
   const categoryId = req.body.categoryId;
   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_CATEGORY, [categoryId]);

      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
         saleObjectsJson.push({
                id: results.rows[i].id,
            title: results.rows[i].title,
            description: results.rows[i].description,
            price: results.rows[i].price,
            date: results.rows[i].date,
            category_id : 1,
            owner_id: results.rows[i].owner_id,
            owner_name: results.rows[i].owner_name
         });
      }
 
      res.status(codes.GET_SUCCESS_CODE);
      res.send({results: saleObjectsJson});

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({message: "Invalid input"});

      throw e
   } finally {
      client.release()
   }
}

getAllByOwnerId = async (req, res) => {
   const ownerId = req.body.ownerId;
   const client = await pool.connect()

   try {
      const result = await client.query(sql.SALE_OBJECT_READ_OWNER, [ownerId]);

      let saleObjectsJson = [];

      for (i = 0; i < result.rowCount; i++) {
         saleObjectsJson.push({
            id: result.rows[i].id,
            title: result.rows[0].title,
            description: result.rows[0].description,
            price: result.rows[0].price,
            categoryId: result.rows[0].category_id
         });
      }

      res.status(codes.GET_SUCCESS_CODE);
      res.send({results: saleObjectsJson});

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

      throw e
   } finally {
      client.release()
   }
}

getImage = async (req, res) => {

  const userId = res.locals.decryptedId;
  const index = req.body.index;
  const postId = req.body.postId;

  console.log(`Requested image with index ${index} of post with id ${postId}`);

   const client = await pool.connect()

   try {
      const results = await client.query(sql.OBJECT_IMAGE_READ, [postId]);
      const fileSrc = results.rows[index].data;

      const filePath = path.resolve(__dirname + '../../../' +  fileSrc);
      console.log(filePath);
      res.sendFile(filePath);
      res.status(codes.GET_SUCCESS_CODE);

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input"});
      throw e
   } finally {
      client.release()
   }

}

module.exports = {
   getCategories,
   insert,
   getAllFromCategory,
   getAllByOwnerId,
   getAll,
   getImage
}