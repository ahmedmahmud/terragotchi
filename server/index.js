const express = require('express')
var bodyParser = require('body-parser')

const app = express()
const port = 3000

let db = {}

// parse application/json
app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.send('Terragotchi server')
})

app.post('/terra_hook', (req, res) => {
  switch (req.body.type) {
    case "auth":
      register_user(req.body.user.user_id);
      break;
    case "user_reauth":
      update_user();
      break;
    case "activity":
      load_activity_data(req.body.user.user_id, req.body.MET_data);
    default:
      break;
  }
  res.end(JSON.stringify(req.body.type, null, 2))
})

// POST Handler that receives user actions
app.post('/send_action/:user_id', (req, res) => {
  switch (req.body.type) {
    case "recycle":
      // reward user for recycling
      break;
    default:
      break;
  }
})

// GET Handler that returns the user their bar values
app.get('/get_values/:user_id', (req, res) => {
  res.json(db[req.params.user_id])
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

register_user = (uid) => {
  db[uid] = {
    "health": 0,
    "environment": 0
  }
  console.log(db)
}

update_user = (old_uid, new_uid) => {
  db[new_uid] = db[old_uid];
  delete db[old_uid];
}

load_activity_data = (uid, data) => {
  let moderate_minutes = data.num_moderate_intensity_minutes;
  let high_minutes = data.num_high_intensity_minutes;

  let score = Math.floor(moderate_minutes / 10 + high_minutes / 3)

  db[uid].health += score;
}