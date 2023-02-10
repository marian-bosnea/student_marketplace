//#region  Authentication

module.exports.CREDENTIALS_INSERT = 'INSERT INTO authentication_credentials (email, password) VALUES ($1, $2) RETURNING id';
module.exports.CREDENTIALS_READ_EMAIL = 'SELECT * FROM authentication_credentials WHERE email = $1';
module.exports.CREDENTIALS_READ_ID = 'SELECT * FROM  authentication_credentials WHERE id = $1';

module.exports.USER_PROFILE_INSERT_FULL = 'INSERT INTO user_profile (first_name, last_name, secondary_last_name, avatar_image) VALUES ($1, $2, $3, $4) RETURNING id';

module.exports.USER_CENTRALIZED_INSERT = 'INSERT INTO user_centralized (role_id, credentials_id, profile_id, faculty_id) VALUES ($1, $2, $3, $4) RETURNING id';
module.exports.FACULTY_READ_ALL = "SELECT * FROM faculty";


// Order of inseration must be: credentials -> profile -> user_centralized
//#endregion

//#region Sale
module.exports.CATEGORY_READ_ALL = "SELECT * FROM object_category";

module.exports.SALE_OBJECT_DESCRIPTION_INSERT = "INSERT INTO object_description (title, description, price) VALUES ($1, $2, $3) RETURNING id";
module.exports.OBJECT_IMAGE_INSERT = "INSERT INTO object_image (data, description_id) VALUES ($1, $2)"
module.exports.SALE_OBJECT_INSERT = "INSERT INTO sale_object (description_id, category_id, owner_id, date, is_active) VALUES ($1, $2, $3, $4, $5) RETURNING id";
module.exports.SALE_OBJECT_READ_CATEGORY = "SELECT d.title, d.description, d.price, o.owner_id FROM object_description d INNER JOIN sale_object o ON o.description_id = d.id WHERE o.category_id = $1";

module.exports.SALE_OBJECT_READ_OWNER = "SELECT d.title, d.description, d.price, o.category_id FROM object_description d INNER JOIN sale_object o ON o.description_id = d.id WHERE o.owner_id = $1";

// Order of inseration must be: description -> images -> sale_object
//#endregion