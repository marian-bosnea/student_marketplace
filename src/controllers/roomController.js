const { pool } = require("../db/dbConfig");
const sql = require('../db/sqlQuerries');
const codes = require('../constants/statusCodes');

insert = async (first_user_id, second_user_id, last_message, last_message_time) => {
    const client = await pool.connect();

    try {
        const result = await client.query(sql.ROOM_INSERT, [first_user_id, second_user_id, last_message, last_message_time]);
        return result.rows[0].id;
    } catch (e) {
        console.log(e);
        return null;
    } finally {
        client.release();
    }


}

read = async (req, res) => {
    const client = await pool.connect();
    const userId = res.locals.decryptedId;

    try {
        const results = await client.query(sql.ROOM_READ_PARTICIPANT1, [userId]);

        var rooms = [];

        for (i = 0; i < results.rows.length; i++) {
            const r = results.rows[i];
            rooms.push({
                id: r.id,
                last_message: r.last_message,
                last_message_time: r.last_message_time,
                partner_id: r.partner_id,
                partner_name: r.partner_name
            });
          console.log(r);
        }
 
        const results2 = await client.query(sql.ROOM_READ_PARTICIPANT2, [userId]);


        for (i = 0; i < results2.rows.length; i++) {
            const r = results2.rows[i];
            rooms.push({
                id: r.id,
                last_message: r.last_message,
                last_message_time: r.last_message_time,
                partner_id: r.partner_id,
                partner_name: r.partner_name
            });
            console.log(r);
        }

        res.status(codes.POST_SUCCESS_CODE).send(rooms);

    } catch (e) {
        res.status(codes.INVALID_INPUT_CODE)
        res.send({ message: e.message });
    } finally {
        client.release();
    }
}

checkIfExists = async (userId, partnerId) => {
    const client = await pool.connect();

    try {
        const result = await client.query(sql.ROOM_READ_PARTICIPANTS, [userId, partnerId]);
        return result.rows[0].id;
    } catch (e) {
        console.log(e);
        return null;
    } finally {
        client.release();
    }
}


update = async (roomId, message, time) => {
    const client = await pool.connect();

    try {
        const results = await client.query(sql.ROOM_MODIFY, [roomId, message, time]);
        return results;
    } catch (e) {
        return [];
    } finally {
        client.release();
    }
}

module.exports = {
    insert,
    read,
    update,
    checkIfExists
}