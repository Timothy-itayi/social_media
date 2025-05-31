const pool = require('../db/db');

const getAllPosts = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM posts');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'Server error' });
  }
};

const createPost = async (req, res) => {
  try {
    const { content, username } = req.body;

    if (!content || !username) {
      return res.status(400).json({ error: 'Content and username are required' });
    }

    const insertQuery = `
      INSERT INTO posts (content, username)
      VALUES ($1, $2)
      RETURNING *;
    `;

    const result = await pool.query(insertQuery, [content, username]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'Server error' });
  }
};


module.exports = {
  getAllPosts,
  createPost,
};
