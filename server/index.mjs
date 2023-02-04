// ---- IMPORTS ---- //
import express from 'express'
import bodyParser from 'body-parser'
import { Low } from 'lowdb'
import { JSONFile } from 'lowdb/node'

import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

// ---- DATABASE SETUP ---- //
const __dirname = dirname(fileURLToPath(import.meta.url));
const file = join(__dirname, 'db.json')

const adapter = new JSONFile(file)
const db = new Low(adapter)

await db.read()
db.data ||= {}

// ---- SERVER SETUP ---- //
const app = express()
const port = 3000

// ---- MIDDLEWARE ---- //
app.use(bodyParser.json())

// ---- GET HANDLERS ---- //
app.get('/', (req, res) => {
  res.send('🌍 Terragotchi 🌍')
})

app.get('/get_values/:user_id', (req, res) => {
  res.json(db.data[req.params.user_id])
})

// ---- POST HANDLERS ---- //
app.post('/terra_hook', async (req, res) => {
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
  res.sendStatus(200)
  await db.write()
})

app.post('/send_action/:user_id', async (req, res) => {
  switch (req.body.type) {
    case "recycle":
      // reward user for recycling
      inc_recycle(req.params.user_id)
      res.sendStatus(200)
      break
    case "summary":
      report_daily_summary(req.params.user_id, req.body)
      res.sendStatus(200)
    default:
      res.sendStatus(404)
      break
  }
  await db.write()
})

// ---- HELPER / HANDLERS ---- //
let register_user = (uid) => {
  if (!(uid in db.data)) {
    db.data[uid] = {
      "health": 0,
      "environment": 0
    }
    console.log(`🔧 Successfully registered ${color.magenta(uid)} to the database!`)
  } else {
    console.log(`🖇️ ${color.red(uid)} already exists! Ignoring...`)
  }
}

let update_user = (old_uid, new_uid) => {
  if (old_uid in db.data && !(new_uid in db.data)) {
    db.data[new_uid] = db.data[old_uid];
    delete db.data[old_uid];
    console.log(`🔧 User re-registered from ${color.red(old_uid)} to ${color.magenta(new_uid)}!`)
  } else {
    console.log(`🔧 Re-register ${color.red("failed")}!`)
  }
}

let load_activity_data = (uid, data) => {
  let moderate_minutes = data.num_moderate_intensity_minutes
  let high_minutes = data.num_high_intensity_minutes
  
  let score = Math.floor(moderate_minutes / 10 + high_minutes / 3)
  
  db.data[uid].health += score
  console.log(`🏋️ ${color.magenta(old_uid)} completed an activity, updating scores!`)
}

let inc_recycle = (uid) => {
  db.data[uid].environment += 2
  console.log(db.data)
}

let report_daily_summary = (uid, data) => {
  let dbe = db.data[uid]
  let score = 0
  score += calculate_transport_score(data.transport)
  
  if (data.recycled == true) {
    score += 10
  }
  
  score += data.meals.map(calculate_meal_score).reduce((sum, a) => sum + a, 0)
  dbe.environment += score
  console.log(db.data)
}

let calculate_transport_score = (transport) => {
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

let calculate_meal_score = (meal) => {
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

// ---- LOGGING HELPERS ---- //
const color = {
  reset: "\x1b[0m",
  black: (msg) => `\x1b[30m${msg}${color.reset}`,
  red: (msg) => `\x1b[31m${msg}${color.reset}`,
  green: (msg) => `\x1b[32m${msg}${color.reset}`,
  yellow: (msg) => `\x1b[33m${msg}${color.reset}`,
  blue: (msg) => `\x1b[34m${msg}${color.reset}`,
  magenta: (msg) => `\x1b[35m${msg}${color.reset}`,
  cyan: (msg) => `\x1b[36m${msg}${color.reset}`,
  white: (msg) => `\x1b[37m${msg}${color.reset}`,
  gray: (msg) => `\x1b[90m${msg}${color.reset}`,
}

// ---- SERVER LISTEN ---- //
app.listen(port, () => {
  console.log(`🚀 terragatchi server running on ${color.green(port)}!`)
})