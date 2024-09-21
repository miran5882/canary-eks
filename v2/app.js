const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello from Version 2 (Canary)!');
});

app.listen(port, () => {
  console.log(`App version 2 (Canary) listening at http://localhost:${port}`);
});
