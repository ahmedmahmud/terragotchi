const express = require('express')
var bodyParser = require('body-parser')

const app = express()
const port = 3000

// parse application/json
app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.send('Terragotchi server')
})

app.post('/terra_hook', (req, res) => {
  switch (req.body.type) {
    case "user":
      
      break;
  
    default:
      break;
  }
  res.end(JSON.stringify(req.body.type, null, 2))
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})