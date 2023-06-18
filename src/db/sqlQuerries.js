//#region  Authentication

module.exports.CREDENTIALS_INSERT = `
INSERT INTO authentication_credentials (email, password) 
VALUES ($1, $2) RETURNING id`;

module.exports.CREDENTIALS_READ_EMAIL = `
SELECT u.id, c.email, c.password 
FROM user_centralized u 
INNER JOIN authentication_credentials c ON c.id = u.credentials_id
WHERE email = $1`;

module.exports.CREDENTIALS_READ_ID = `SELECT * FROM  authentication_credentials WHERE id = $1`;

module.exports.USER_PROFILE_INSERT_FULL = `
INSERT INTO user_profile (first_name, last_name, secondary_last_name, avatar_image)
VALUES ($1, $2, $3, $4)
RETURNING id`;

module.exports.USER_CENTRALIZED_INSERT = `
INSERT INTO user_centralized (role_id, credentials_id, profile_id, faculty_id)
VALUES ($1, $2, $3, $4)
RETURNING id`;

module.exports.FACULTY_READ_ALL = `SELECT * FROM faculty`;

module.exports.USER_PROFILE_READ = `
SELECT p.first_name, p.last_name, p.secondary_last_name, p.avatar_image, f.name As faculty_name 
FROM user_profile p INNER JOIN user_centralized u ON u.profile_id = p.id
INNER JOIN faculty f  ON u.faculty_id = f.id WHERE u.id = $1`;

module.exports.UPDATE_PROFILE_AVATAR = `
UPDATE user_profile SET avatar_image = $1 WHERE id = $2`;

module.exports.GET_PROFILE_ID = `
SELECT profile_id FROM user_centralized WHERE id = $1`;

module.exports.GET_USER_AVATAR = `
SELECT p.avatar_image FROM user_profile p 
INNER JOIN user_centralized u ON u.profile_id = p.id 
WHERE u.id = $1`;

// Order of inseration must be: credentials -> profile -> user_centralized
//#endregion

module.exports.INSERT_TOKEN = `INSERT INTO authorization_token (token) VALUES ($1)`;
module.exports.READ_TOKEN = `SELECT * FROM authorization_token WHERE token = $1`;
module.exports.DELETE_TOKEN = `DELETE FROM authorization_token WHERE token = $1`;
//#region Sale
module.exports.CATEGORY_READ_ALL = `SELECT * FROM object_category`;

// module.exports.SALE_OBJECT_READ_ALL = `
// SELECT o.id, d.title, d.price, o.views_count, o.owner_id, o.category_id
// FROM object_description d 
// INNER JOIN sale_object o ON o.description_id = d.id
// ORDER BY o.date ASC
// LIMIT $1
// OFFSET $2
// `;

module.exports.SALE_OBJECT_READ_ALL = `
SELECT
  o.id,
  d.title,
  d.price,
  o.views_count,
  o.owner_id,
  o.category_id,
  (CASE WHEN f.post_id IS NULL THEN false ELSE true END) AS is_favorite
FROM
  object_description d
INNER JOIN
  sale_object o ON o.description_id = d.id
LEFT JOIN
  favorite_post f ON f.user_id = $1 AND f.post_id = o.id
ORDER BY
  o.id ASC
LIMIT $2
OFFSET $3;
`;

module.exports.SALE_OBJECT_READ_DETAILED = `
SELECT o.id, d.title, d.description, d.price, o.date, oc.name as category_name, o.views_count, 
o.owner_id, p.last_name as owner_name, d.id as description_id 
FROM object_description d 
INNER JOIN sale_object o ON o.description_id = d.id 
INNER JOIN user_centralized c ON o.owner_id = c.id 
INNER JOIN user_profile p ON p.id = c.profile_id 
INNER JOIN object_category oc ON o.category_id = oc.id 
WHERE o.id = $1`;

module.exports.SALE_OBJECT_IMAGE_COUNT = `
SELECT COUNT(data)
FROM object_image o
WHERE o.description_id = $1`;

module.exports.SALE_OBJECT_INCREMENT_VIEWS_COUNT = `
UPDATE sale_object
SET views_count = views_count + 1
WHERE id = $1`;

module.exports.SALE_OBJECT_DESCRIPTION_INSERT = `
INSERT INTO object_description (title, description, price) 
VALUES ($1, $2, $3)
RETURNING id`;

module.exports.OBJECT_IMAGE_INSERT = `INSERT INTO object_image (data, description_id) VALUES ($1, $2)`;
module.exports.OBJECT_IMAGE_READ = `
SELECT i.data FROM object_image i
INNER JOIN object_description d ON d.id = i.description_id
INNER JOIN sale_object s ON s.description_id = d.id
WHERE s.id =$1`;

module.exports.SALE_OBJECT_INSERT = `
INSERT INTO sale_object (description_id, category_id, owner_id, date, is_active) 
VALUES ($1, $2, $3, $4, $5)
 RETURNING id`;

module.exports.SALE_OBJECT_READ_CATEGORY = `
SELECT
  o.id,
  d.title,
  d.price,
  o.views_count,
  o.owner_id,
  o.category_id,
  (CASE WHEN f.post_id IS NULL THEN false ELSE true END) AS is_favorite
FROM
  object_description d
INNER JOIN
  sale_object o ON o.description_id = d.id
LEFT JOIN
  favorite_post f ON f.user_id = $1 AND f.post_id = o.id
WHERE
  o.category_id = $2
ORDER BY
  o.id ASC
LIMIT $3
OFFSET $4;`;

module.exports.SALE_OBJECT_UPDATE_DESCRIPTION = `
UPDATE object_description SET title = $1, description = $2, price = $3
FROM sale_object
WHERE object_description.id = sale_object.description_id AND sale_object.id = $4 
RETURNING object_description.id;`;

module.exports.SALE_OBJECT_UPDATE_CATEGORY = `UPDATE sale_object s SET category_id = $1 WHERE s.id = $2;`
module.exports.SALE_OBJECT_DELETE_IMAGES = `DELETE FROM object_image 
USING  object_description d, sale_object s
WHERE d.id = object_image.description_id AND s.description_id = d.id AND s.id = $1`;

module.exports.SALE_OBJECT_READ_OWNER = `SELECT o.id, d.title, d.description, d.price, c.name as category_name, o.views_count, o.date
FROM object_description d
INNER JOIN sale_object o ON o.description_id = d.id
INNER JOIN object_category c ON o.category_id = c.id 
WHERE o.owner_id = $1`;

// Order of inseration must be: description -> images -> sale_object
//#endregion

// Favorites

module.exports.SALE_OBJECT_ADD_TO_FAVORITE = `
INSERT INTO favorite_post (user_id, post_id) 
VALUES ($1, $2)`;
module.exports.SALE_OBJECT_REMOVE_FROM_FAVORITES = `
DELETE FROM favorite_post 
WHERE user_id = $1 AND post_id = $2`;

module.exports.SALE_OBJECT_READ_ALL_FAVORITES = `
SELECT s.id, d.title, d.price, s.views_count, c.name as category_name, u.id as owner_id, p.last_name as owner_name 
FROM sale_object s 
INNER JOIN favorite_post f ON f.post_id = s.id
INNER JOIN object_category c ON s.category_id = c.id
INNER JOIN user_centralized u ON s.owner_id = u.id
INNER JOIN user_profile p ON u.profile_id  = p.id 
INNER JOIN object_description d ON s.description_id = d.id
WHERE f.user_id = $1`;

module.exports.SALE_OBJECT_CHECK_IF_FAVORITE = `
SELECT post_id 
FROM favorite_post 
WHERE user_id = $1 AND post_id = $2`;

// Adress

module.exports.ADDRESS_INSERT = `
INSERT INTO address (owner_id, name, county, city, description)
VALUES ($1, $2, $3, $4, $5)`;
module.exports.ADDRESS_READ = `SELECT * FROM address WHERE owner_id = $1`
module.exports.ADDRESS_UPDATE = `
UPDATE address SET name = $1 , county = $2, city = $3, description = $4
 WHERE owner_id = $5`;
module.exports.ADDRESS_DELETE = `DELETE FROM address WHERE id = $1`;

// Order

module.exports.ORDER_INSERT = `
INSERT INTO orders (buyer_id, object_id, address_id, notes, date, awb, status)
 VALUES($1, $2, $3, $4, $5, $6, $7)`;

module.exports.ORDER_READ_BUYER = `
SELECT o.id, o.object_id, d.title as object_title, u.id as owner_id, p.last_name as owner_name, a.name as address_name, o.notes, o.awb, o.status, o.date 
FROM orders o 
INNER JOIN address a ON a.id = o.address_id 
INNER JOIN sale_object s ON o.object_id = s.id 
INNER JOIN object_description d ON s.description_id = d.id 
INNER JOIN user_centralized u ON s.owner_id = u.id 
INNER JOIN user_profile p ON u.profile_id = p.id 
WHERE buyer_id = $1`;

module.exports.ORDER_READ_SELLER = `
SELECT o.id, o.object_id, d.title AS object_title, o.buyer_id AS buyer_id, p.last_name AS buyer_name, CONCAT('Jud. ', a.county, ', Loc.', a.city, ', Adresa: ', a.description) AS address_name, o.notes, o.awb, o.status, o.date
FROM orders o
INNER JOIN address a ON a.id = o.address_id 
INNER JOIN sale_object s ON o.object_id = s.id 
INNER JOIN object_description d ON s.description_id = d.id 
INNER JOIN user_centralized u ON o.buyer_id = u.id
INNER JOIN user_profile p ON u.profile_id = p.id
WHERE s.owner_id = $1`;

module.exports.ORDER_UPDATE = `UPDATE orders SET status = $1, awb = $2, date = $3 WHERE id = $4`;
module.exports.ORDER_DELETE = `DELETE FROM orders WHERE id = $1`;


// Room
module.exports.ROOM_INSERT = "INSERT INTO room (first_user_id, second_user_id, last_message, last_message_time) VALUES ($1, $2, $3, $4) RETURNING id";

module.exports.ROOM_READ_PARTICIPANT1 = `
SELECT r.id, r.last_message, r.last_message_time, r.second_user_id as partner_id ,CONCAT(p.first_name, ' ', p.last_name) as partner_name 
FROM room r
INNER JOIN user_centralized u ON u.id = r.second_user_id 
INNER JOIN user_profile p ON u.profile_id = p.id
WHERE first_user_id = $1
AND r.last_message IS NOT NULL
`;

module.exports.ROOM_READ_PARTICIPANT2 = `
SELECT r.id, r.last_message, r.last_message_time, r.first_user_id as partner_id ,CONCAT(p.first_name, ' ', p.last_name) as partner_name 
FROM room r
INNER JOIN user_centralized u ON u.id = r.first_user_id 
INNER JOIN user_profile p ON u.profile_id = p.id
WHERE second_user_id = $1
AND r.last_message IS NOT NULL
`;



module.exports.ROOM_READ_PARTICIPANTS = `
SELECT * FROM room 
WHERE(first_user_id = $1 AND second_user_id =  $2) OR (first_user_id =  $2 AND second_user_id =  $1) `;

module.exports.ROOM_MODIFY = "UPDATE room SET last_message = $1, last_message_time = $2 WHERE id = $3";

// Messages
module.exports.MESSAGE_INSERT = `
INSERT INTO message (room_id, content, time, sender_id) 
VALUES ($1, $2, $3, $4) 
RETURNING id`;

module.exports.MESSAGES_READ_ROOM = `
SELECT m.content, m.time, p.last_name as sender_name, m.sender_id
FROM  message m 
INNER JOIN user_centralized u ON u.id = m.sender_id
INNER JOIN user_profile p ON u.profile_id = p.id
WHERE room_id = $1
`;
