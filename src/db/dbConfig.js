require("dotenv").config();

const { Pool } = require("pg");

const isProduction = process.env.NODE_ENV === "production";

//const connectionString = `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_DATABASE}`;
const connectionString = `postgres://marianbosnea:Haarpcord2233@unimarketplace-db.postgres.database.azure.com/postgres?sslmode=require`
console.log(connectionString);

const pool = new Pool({
    connectionString: isProduction ? process.env.DATABASE_URL : connectionString
});

module.exports = { pool }
