const express = require('express');
const app = express();
// Render sets the PORT environment variable dynamically
const port = process.env.PORT || 8000; 

// The static files will be served directly by Caddy, but the Node.js
// server can handle dynamic requests.
app.get('/api', (req, res) => {
  res.json({ message: 'Hello from the Node.js API!' });
});

app.listen(port, () => {
  console.log(`Node.js server listening on port ${port}`);
});
