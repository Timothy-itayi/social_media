const express = require('express');
const cors = require('cors');
require('dotenv').config();

const postRoutes = require('./routes/posts');

const app = express();
const PORT = process.env.PORT || 8080;


app.use((req, res, next) => {
  console.log(`Incoming request: ${req.method} ${req.url}`);
  next();
});

app.use(cors({
    origin: '*',
}));
app.use(express.json());

app.use('/api/posts', postRoutes);

app.get('/', (req, res) => {
      console.log('GET / hit');
  res.send('SlipStream backend is running!');
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
