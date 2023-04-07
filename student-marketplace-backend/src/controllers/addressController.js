const { pool } = require("../db/dbConfig");
const bcrypt = require('bcrypt');
const sharp = require('sharp');

const sql = require('../db/sqlQuerries');
const errMsg = require('../constants/errMessages');
const codes = require('../constants/statusCodes');
const authorization = require('../authorization');

insert = async (req, res) => {

    const owner_id = res.locals.decryptedId;
    const county = req.body.county;
    const city = req.body.city;
    const description = req.body.description;
    const name = req.body.name;

    console.log(`Requested creation of address with: ${owner_id}, ${county}, ${city}, ${description} `);
    const client = await pool.connect();

    try {
        await client.query(sql.ADDRESS_INSERT, [owner_id, name, county, city, description]);
        res.status(codes.POST_SUCCESS_CODE).send();
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}




read = async (req, res) => {
    const owner_id = res.locals.decryptedId;

    const client = await pool.connect();

    try {
        const result = await client.query(sql.ADDRESS_READ, [owner_id]);
        var addresses = [];
        for (var i = 0; i < result.rows.length; i++) {
            const addr = result.rows[i];
            addresses.push({
                id: addr.id,
                name: addr.name,
                county: addr.county,
                city: addr.city,
                description: addr.description
            });
        }

        res.status(codes.POST_SUCCESS_CODE).send(addresses);
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}

update = async (req, res) => {
    const owner_id = res.locals.decryptedId;
    const county = req.body.county;
    const city = req.body.city;
    const description = req.body.description;
    const name = req.body.name

    const client = await pool.connect();

    try {
        await client.query(sql.ADDRESS_UPDATE, [name, county, city, description, owner_id]);
        res.status(codes.POST_SUCCESS_CODE).send();
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}

remove = async (req, res) => {
    const id = req.body.id;
    const client = await pool.connect();
    try {
        await client.query(sql.ADDRESS_DELETE, [id]);
        res.status(codes.POST_SUCCESS_CODE).send();
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}



module.exports = {
    insert,
    read,
    update,
    remove
}
