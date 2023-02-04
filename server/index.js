const express = require('express')
var bodyParser = require('body-parser')

const app = express()
const port = 3000

// parse application/json
app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.send('Terragotchi server')
})

app.get('/terra_hook', (req, res) => {
  res.setHeader('Content-Type', 'text/plain')
  res.write('you posted:\n')
  res.end(JSON.stringify(req.body, null, 2))
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})