const express = require('express')
var bodyParser = require('body-parser')

const app = express()
const port = 3000

let db = {
  "1": {
    "health": 50,
    "environment": 50
  }
}

// parse application/json
app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.send('Terragotchi server')
})

app.post('/terra_hook', (req, res) => {
  switch (req.body.type) {
    case "auth":
      register_user(req.body.user.user_id)
      break
    case "user_reauth":
      update_user(req.body.old_user.user_id, req.body.new_user.user_id)
      break
    case "activity":
      load_activity_data(req.body.user.user_id, req.body.MET_data)
    default:
      break
  }
  res.end(JSON.stringify(req.body.type, null, 2))
})

// POST Handler that receives user actions
app.post('/send_action/:user_id', (req, res) => {
  switch (req.body.type) {
    case "recycle":
      // reward user for recycling
      inc_recycle(req.params.user_id)
      res.send(200)
      break
    case "summary":
      report_daily_summary(req.params.user_id, req.body)
      res.send(200)
    default:
      break
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
  db[new_uid] = db[old_uid]
  delete db[old_uid]
  console.log(db)
}

load_activity_data = (uid, data) => {
  let moderate_minutes = data.num_moderate_intensity_minutes
  let high_minutes = data.num_high_intensity_minutes

  let score = Math.floor(moderate_minutes / 10 + high_minutes / 3)

  db[uid].health += score
  console.log(db)
}

inc_recycle = (uid) => {
  db[uid].environment += 2
  console.log(db)
}

report_daily_summary = (uid, data) => {
  let dbe = db[uid]
  let score = 0
  score += calculate_transport_score(data.transport)

  if (data.recycled == true) {
    score += 10
  }

  score += data.meals.map(calculate_meal_score).reduce((sum, a) => sum + a, 0)
  dbe.environment += score
  console.log(db)
}

calculate_transport_score = (transport) => {
  let score = 0
  if (transport.includes("walk")) {
    score += 10
  } if (transport.includes("cycle")) {
    score += 10
  } if (transport.includes("bus")) {
    score += 5
  } if (transport.includes("car")) {
    score -= 20
  }
  return score
}

calculate_meal_score = (meal) => {
  switch (meal) {
    case "self":
      return 10
      break;
    case "bought":
      return -5
    case "delivery":
      return -15
  }
}