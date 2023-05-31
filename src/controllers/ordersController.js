
const { pool } = require("../db/dbConfig");
const bcrypt = require('bcrypt');
const sharp = require('sharp');

const sql = require('../db/sqlQuerries');
const errMsg = require('../constants/errMessages');
const codes = require('../constants/statusCodes');
const authorization = require('../authorization');

insert = async (req, res) => {
    const buyer_id = res.locals.decryptedId;
    const object_id = req.body.object_id;
    const address_id = req.body.address_id;
    const notes = req.body.notes;
    const date = req.body.date;
    const awb = '';
    const status = 0;


    console.log(`Requested creation of orders with: ${buyer_id}, ${notes}`);
    const client = await pool.connect();

    try {
        await client.query(sql.ORDER_INSERT, [buyer_id, object_id, address_id, notes, date, awb, status]);
        res.status(codes.POST_SUCCESS_CODE).send();
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}



readByBuyer = async (req, res) => {
    const owner_id = res.locals.decryptedId;
    const client = await pool.connect();
    try {
        const result = await client.query(sql.ORDER_READ_BUYER, [owner_id]);
        var orders = [];
        for (var i = 0; i < result.rows.length; i++) {
            const ord = result.rows[i];
            orders.push({
                id: ord.id,
                object_id: ord.object_id,
                object_title: ord.object_title,
                partner_id: ord.owner_id,
                partner_name: ord.owner_name,
                address_name: ord.address_name,
                notes: ord.notes,
                awb: ord.awb,
                status: ord.status,
                date: ord.date
            });
        }
        console.log(orders);

        res.status(codes.POST_SUCCESS_CODE).send(orders);
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}

readBySeller = async (req, res) => {
    const owner_id = res.locals.decryptedId;
    const client = await pool.connect();

    try {
        const result = await client.query(sql.ORDER_READ_SELLER, [owner_id]);
        var orders = [];
        for (var i = 0; i < result.rows.length; i++) {
            const ord = result.rows[i];
            orders.push({
                id: ord.id,
                object_id: ord.object_id,
                object_title: ord.object_title,
                partner_id: ord.buyer_id,
                partner_name: ord.buyer_name,
                address_name: ord.address_name,
                notes: ord.notes,
                awb: ord.awb,
                status: ord.status,
                date: ord.date
            });
        }
        res.status(codes.POST_SUCCESS_CODE).send(orders);
    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}


update = async (req, res) => {
    const id = req.body.id;
    const awb = req.body.awb;
    const status = req.body.status;
    const date = req.body.date;
    console.log(`Requested order update with ${id} ${awb} ${status} ${date}`);
    const client = await pool.connect();

    try {
        await client.query(sql.ORDER_UPDATE, [status, awb, date, id]);
        res.status(codes.POST_SUCCESS_CODE).send();
    } catch (e) {
        console.log(e.message);
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
        await client.query(sql.ORDER_DELETE, [id]);
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
    readByBuyer,
    readBySeller,
    update,
    remove
}
