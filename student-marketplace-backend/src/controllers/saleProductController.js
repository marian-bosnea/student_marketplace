const fuzzySearch = require('../utils/fuzzySearch')

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

update = async (req, res) => {
   const id = req.body.id;
   const title = req.body.title;
   const description = req.body.description;
   const price = req.body.price;
   const categoryID = req.body.categoryId;

   const client = await pool.connect()

   try {
      await client.query('BEGIN')
      const result = await client.query(sql.SALE_OBJECT_UPDATE_DESCRIPTION, [title, description, price, id]);
      const descriptionId = result.rows[0].id;
   
      await client.query(sql.SALE_OBJECT_UPDATE_CATEGORY, [categoryID, id]);
      await client.query(sql.SALE_OBJECT_DELETE_IMAGES, [id]);
      var paths = req.files.map(file => file.path)

      for (var p in paths) {
          await client.query(sql.OBJECT_IMAGE_INSERT, [paths[p], descriptionId]);
      }

      await client.query('COMMIT')

      res.status(codes.POST_SUCCESS_CODE);
     // res.send({ id: objectRes.rows[0].id });

   } catch (e) {
      console.log(e);
      await client.query('ROLLBACK');
      res.status(codes.INVALID_INPUT_ODE);
      res.send({ message: "Invalid input" });
   } finally {
      client.release()
   }
}

getDetailedSalePost = async (req, res) => {
   const postId = req.body.postId;
   const userId = res.locals.decryptedId;

   const client = await pool.connect()

   await client.query(sql.SALE_OBJECT_INCREMENT_VIEWS_COUNT, [postId]);

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_DETAILED, [postId]);
      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
         const countResult = await client.query(sql.SALE_OBJECT_IMAGE_COUNT, [results.rows[i].description_id]);
         saleObjectsJson.push({
            id: results.rows[i].id,
            title: results.rows[i].title,
            description: results.rows[i].description,
            price: results.rows[i].price,
            date: results.rows[i].date,
            category_name: results.rows[i].category_name,
            views_count: results.rows[i].views_count,
            owner_id: results.rows[i].owner_id,
            owner_name: results.rows[i].owner_name,
            is_own: results.rows[i].owner_id == userId,
            images_count: countResult.rows[0].count
         });
      }
      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });
   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()

   }


}

getAll = async (req, res) => {
   console.log("Requested all sale posts");
   const client = await pool.connect();
   const userId = res.locals.decryptedId;

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_ALL);
      let saleObjectsJson = [];
      for (i = 0; i < results.rowCount; i++) {
      const isOwn = userId == results.rows[i].owner_id;
      const postId = results.rows[i].id;
      const title = results.rows[i].title;
      const price = results.rows[i].price;
      const viewsCount = results.rows[i].views_count;

      const favResults = await client.query(sql.SALE_OBJECT_CHECK_IF_FAVORITE, [userId, postId]);
      const isFavorite  =   favResults.rowCount != 0;

         saleObjectsJson.push({
            id:postId,
            title: title,
            price: price,
            views_count: viewsCount,
            is_own: isOwn,
            is_favorite: isFavorite
         });
      }

      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });
   
   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });
      throw e
   } finally {
     await client.release()

   }
}


getAllFromCategory = async (req, res) => {
   const categoryId = req.body.categoryId;
   const client = await pool.connect()
   const userId = res.locals.decryptedId;
   try {
      const results = await client.query(sql.SALE_OBJECT_READ_CATEGORY, [categoryId]);

      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
        const isOwnPost = userId == results.rows[i].owner_id;
        const postId = results.rows[i].id;
        const title = results.rows[i].title;
        const price = results.rows[i].price;
        const viewsCount = results.rows[i].views_count;
        const favResult = await pool.query(sql.SALE_OBJECT_CHECK_IF_FAVORITE, [userId, postId]);

         saleObjectsJson.push({
            id:postId,
            title: title,
            price: price,
            views_count: viewsCount,
            is_own: isOwnPost,
            is_favorite: favResult.rowCount > 0
         });
      }

      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

      throw e
   } finally {
      client.release()
   }
}

searchWithTextQuery = async (req, res) => {
   const query = req.body.query;
   const client = await pool.connect();
   const userId = res.locals.decryptedId;

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_ALL, []);

      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
         const isOwnPost = userId == results.rows[i].owner_id;
         const postId = results.rows[i].id;
         const title = results.rows[i].title;
         const price = results.rows[i].price;
         const category_id = results.rows[i].category_id;
         const viewsCount = results.rows[i].views_count;
 
          const favResult = await pool.query(sql.SALE_OBJECT_CHECK_IF_FAVORITE, [userId, postId]);
 
          saleObjectsJson.push({
             id:postId,
             title: title,
             price: price,
             views_count: viewsCount,
             is_own: isOwnPost,
             is_favorite: favResult.rowCount > 0,
             category_id: category_id
          });
      }

      const filteredResults = fuzzySearch.search(saleObjectsJson, query);
      saleObjectsJson = [];

      for (i = 0; i < filteredResults.length; i++) {
         saleObjectsJson.push(filteredResults[i].item);
      }

      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

      throw e
   } finally {
      client.release()
   }
}

getAllByOwnerId = async (req, res) => {
   var userId = req.body.ownerId;


   if(userId == -1 || userId == null){
   userId = res.locals.decryptedId;
   }

   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_OWNER, [userId]);

      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
         saleObjectsJson.push({
            id: results.rows[i].id,
            title: results.rows[i].title,
            price: results.rows[i].price,
            views_count: results.rows[i].views_count,
            category_name: results.rows[i].category_name,
            date: results.rows[i].date
         });
      }
      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      res.send({ message: "Invalid input" });

      throw e
   } finally {
      client.release()
   }
}

getImage = async (req, res) => {
   const index = req.body.index;
   const postId = req.body.postId;

   const client = await pool.connect()

   try {
      const results = await client.query(sql.OBJECT_IMAGE_READ, [postId]);
      const fileSrc = results.rows[index].data;
      const filePath = path.resolve(__dirname + '../../../' + fileSrc);
      res.sendFile(filePath);
      res.status(codes.GET_SUCCESS_CODE);

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()
   }

}


addToFavorites = async (req, res) => {
   const postId = req.body.postId;
   const userId = res.locals.decryptedId;

   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_CHECK_IF_FAVORITE, [userId, postId]);

      if (results.rows.length == 0) {
         await client.query(sql.SALE_OBJECT_ADD_TO_FAVORITE, [userId, postId]);
      }

      res.status(codes.POST_SUCCESS_CODE).send();

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()
   }
}

checkIfFavorite = async (req, res) => {
   const postId = req.body.postId;
   const userId = res.locals.decryptedId;

   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_CHECK_IF_FAVORITE, [userId, postId]);

      if (results.rows.length == 0) {
         res.status(codes.POST_SUCCESS_CODE).send({ result: false });
      } else {
         res.status(codes.POST_SUCCESS_CODE).send({ result: true });
      }

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()
   }
}

readAllFavorites = async (req, res) => {
   const userId = res.locals.decryptedId;
   const client = await pool.connect()

   try {
      const results = await client.query(sql.SALE_OBJECT_READ_ALL_FAVORITES, [userId]);
      let saleObjectsJson = [];

      for (i = 0; i < results.rowCount; i++) {
         saleObjectsJson.push({
            id: results.rows[i].id,
            title: results.rows[i].title,
            price: results.rows[i].price,
            category_name: results.rows[i].category_name,
            owner_id: results.rows[i].owner_id,
            owner_name: results.rows[i].owner_name,
            views_count: results.rows[i].views_count,
         });
      }

      res.status(codes.GET_SUCCESS_CODE);
      res.send({ results: saleObjectsJson });

   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()
   }
}

removeFromFavorites = async (req, res) => {
   const postId = req.body.postId;
   const userId = res.locals.decryptedId;

   const client = await pool.connect();

   try {
    await client.query(sql.SALE_OBJECT_REMOVE_FROM_FAVORITES, [userId, postId]);
      res.status(codes.POST_SUCCESS_CODE).send();
      
   } catch (e) {
      res.status(codes.INVALID_INPUT_CODE);
      console.log('error');
      res.send({ message: "Invalid input" });
      throw e
   } finally {
      client.release()
   }
}

module.exports = {
   getCategories,
   insert,
   update,
   getAllFromCategory,
   getAllByOwnerId,
   getAll,
   getImage,
   getDetailedSalePost,
   searchWithTextQuery,
   addToFavorites,
   checkIfFavorite,
   readAllFavorites,
   removeFromFavorites
}