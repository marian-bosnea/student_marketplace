//#region  Authentication

module.exports.CREDENTIALS_INSERT = 'INSERT INTO authentication_credentials (email, password) VALUES ($1, $2) RETURNING id';
module.exports.CREDENTIALS_READ_EMAIL = 'SELECT u.id, c.email, c.password FROM user_centralized u INNER JOIN authentication_credentials c ON c.id = u.credentials_id WHERE email = $1'
module.exports.CREDENTIALS_READ_ID = 'SELECT * FROM  authentication_credentials WHERE id = $1';

module.exports.USER_PROFILE_INSERT_FULL = 'INSERT INTO user_profile (first_name, last_name, secondary_last_name, avatar_image) VALUES ($1, $2, $3, $4) RETURNING id';

module.exports.USER_CENTRALIZED_INSERT = 'INSERT INTO user_centralized (role_id, credentials_id, profile_id, faculty_id) VALUES ($1, $2, $3, $4) RETURNING id';
module.exports.FACULTY_READ_ALL = 'SELECT * FROM faculty';

module.exports.USER_PROFILE_READ = 'SELECT p.first_name, p.last_name, p.secondary_last_name, p.avatar_image, f.name As faculty_name FROM user_profile p INNER JOIN user_centralized u ON u.profile_id = p.id INNER JOIN faculty f  ON u.faculty_id = f.id WHERE u.id = $1';
module.exports.UPDATE_PROFILE_AVATAR = 'UPDATE user_profile SET avatar_image = $1 WHERE id = $2';

module.exports.GET_PROFILE_ID = 'SELECT profile_id FROM user_centralized WHERE id = $1';
module.exports.GET_USER_AVATAR = 'SELECT p.avatar_image FROM user_profile p INNER JOIN user_centralized u ON u.profile_id = p.id WHERE u.id = $1';
// Order of inseration must be: credentials -> profile -> user_centralized
//#endregion

module.exports.INSERT_TOKEN = 'INSERT INTO authorization_token (token) VALUES ($1)';
module.exports.READ_TOKEN = 'SELECT * FROM authorization_token WHERE token = $1';
module.exports.DELETE_TOKEN = 'DELETE FROM authorization_token WHERE token = $1';
//#region Sale
module.exports.CATEGORY_READ_ALL = 'SELECT * FROM object_category';



module.exports.SALE_OBJECT_READ_ALL = 'SELECT o.id, d.title, d.price FROM object_description d INNER JOIN sale_object o ON o.description_id = d.id';
module.exports.SALE_OBJECT_READ_DETAILED = 'SELECT o.id, d.title, d.description, d.price, o.date, oc.name as category_name, o.views_count, o.owner_id, p.last_name as owner_name, d.id as description_id  FROM object_description d  INNER JOIN sale_object o ON o.description_id = d.id INNER JOIN user_centralized c ON o.owner_id = c.id INNER JOIN user_profile p ON p.id = c.profile_id INNER JOIN object_category oc ON o.category_id = oc.id WHERE o.id = $1';
module.exports.SALE_OBJECT_IMAGE_COUNT = 'SELECT COUNT(data) FROM object_image o WHERE o.description_id = $1';
module.exports.SALE_OBJECT_DESCRIPTION_INSERT = 'INSERT INTO object_description (title, description, price) VALUES ($1, $2, $3) RETURNING id';
module.exports.OBJECT_IMAGE_INSERT = 'INSERT INTO object_image (data, description_id) VALUES ($1, $2)';
module.exports.OBJECT_IMAGE_READ = 'SELECT i.data FROM object_image i INNER JOIN object_description d ON d.id = i.description_id INNER JOIN sale_object s ON s.description_id = d.id WHERE s.id =$1';
module.exports.SALE_OBJECT_INSERT = 'INSERT INTO sale_object (description_id, category_id, owner_id, date, is_active) VALUES ($1, $2, $3, $4, $5) RETURNING id';
module.exports.SALE_OBJECT_READ_CATEGORY = 'SELECT o.id, d.title, d.price FROM object_description d INNER JOIN sale_object o ON o.description_id = d.id WHERE o.category_id = $1';

module.exports.SALE_OBJECT_READ_OWNER = 'SELECT d.title, d.description, d.price, o.category_id FROM object_description d INNER JOIN sale_object o ON o.description_id = d.id WHERE o.owner_id = $1';
// Order of inseration must be: description -> images -> sale_object
//#endregion