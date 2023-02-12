const { pool } = require("../db/dbConfig");
const sql = require('../db/sqlQuerries');

const codes = require('../constants/statusCodes');

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

      res.status(codes.POST_SUCCESS_CODE);
      res.send({ id: objectRes.rows[0].id });

   } catch (e) {
      await client.query('ROLLBACK');
      res.status(code.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

   } finally {

      client.release()
   }
}

getAllFromCategory = async (req, res) => {
   const categoryId = req.body.categoryId;
   const client = await pool.connect()

   try {
      const result = await client.query(sql.SALE_OBJECT_READ_CATEGORY, [categoryId]);

      let saleObjectsJson = [];

      for (i = 0; i < result.rowCount; i++) {
         saleObjectsJson.push({
            title: result.rows[0].title,
            description: result.rows[0].description,
            price: result.rows[0].price,
            ownerId: result.rows[0].owner_id
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

module.exports = {
   getCategories,
   insert,
   getAllFromCategory,
   getAllByOwnerId
}