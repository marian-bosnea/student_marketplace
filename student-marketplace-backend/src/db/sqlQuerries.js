//#region  Authentication

module.exports.CREDENTIALS_INSERT = 'INSERT INTO authentication_credentials (email, password) VALUES ($1, $2)';
module.exports.CREDENTIALS_READ_EMAIL = 'SELECT * FROM authentication_credentials WHERE email = $1';
module.exports.CREDENTIALS_READ_ID = 'SELECT * FROM  authentication_credentials WHERE id = $1';

module.exports.USER_PROFILE_INSERT_FULL = 'INSERT INTO user_profile (first_name, last_name, secondary_last_name, avatar_image) VALUES ($1, $2, $3, $4)'
//#endregion

//#region Faculty
module.exports.FACULTY_READ_ALL = "SELECT * FROM faculty";

//#endregion