const { pool } = require("../db/dbConfig");
const sql = require('../db/sqlQuerries');

insert = async (roomId, content, time, senderId) => {
    const client = await pool.connect();

    try {
        await client.query(sql.MESSAGE_INSERT, [roomId, content, time, senderId]);
    } catch (e) {
        console.log(e);
        return;
    } finally {
        client.release();
    }


}

read =  async (roomId) => {
    const client = await pool.connect();
    try {
        const results = await client.query(sql.MESSAGES_READ_ROOM, [roomId]);
        return results.rows;
    } catch (e) {
        return [];
    } finally {
        client.release();
    }
}

module.exports = {
    insert,
    read
}