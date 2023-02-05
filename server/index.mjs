// ---- IMPORTS ---- //
import util from 'util'
import express from 'express'
import bodyParser from 'body-parser'
import moment from 'moment'
import hash from 'object-hash'
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
db.data.current_id ||= 987656789865
db.data.conv ||= {}

// ---- SERVER SETUP ---- //
const app = express()
const port = 3000

// ---- MIDDLEWARE ---- //
app.use(bodyParser.json())

// ---- GET HANDLERS ---- //
app.get('/', (req, res) => {
  res.send('🌍 Terragotchi 🌍')
})

app.get('/generate_url', async (req, res) => {
  const ref_id = hash(db.data.current_id++)
  await db.write()
  
  fetch('https://api.tryterra.co/v2/auth/generateWidgetSession', {
    method: 'POST',
    headers: {
      "accept": "application/json",
      "dev-id": "enviro-health-tamgotchi-dev-aNdyzr1TgM",
      "content-type": "application/json",
      'x-api-key': '23be8ca410a6d8d2973c47c42f844f9231fd73c6b64496a1b267c96e016ffd20',
    },
    body: JSON.stringify({
      reference_id: ref_id,
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      console.log(`🌍 Generated ${color.cyan(data.url)} for ${color.green(ref_id)}`);
      res.json({ ref_id, url: data.url })
    })
    .catch((error) => {
      console.error(`${color.red(Error)}:`, error);
    });
})

app.get('/get_values/:reference_id', async (req, res) => {
  if (req.params.reference_id in db.data) {
    decay_scores(req.params.reference_id);
    check_scores(req.params.reference_id);
    let rounded = {
      sleep: Math.floor(db.data[req.params.reference_id].sleep),
      planet: Math.floor(db.data[req.params.reference_id].planet),
      health: Math.floor(db.data[req.params.reference_id].health),
    }
    res.json(rounded)
    console.log(`✉️ Sent scores [${color.gray(rounded.sleep)}, ${color.green(rounded.planet)}, ${color.red(rounded.health)}] to ${color.green(req.params.reference_id)}`);
    await db.write()
  } else {
    console.log(`✉️ Failed send`);
  }
})

app.get('/leaderboard', async (req, res) => {
  let scores = []
  for (const ref_id in db.data) {
    if (ref_id != "conv" && ref_id != "current_id") {
      decay_scores(ref_id)
      check_scores(ref_id)
      scores.push({ id: ref_id, score: Math.floor((db.data[ref_id].planet + db.data[ref_id].sleep + db.data[ref_id].health)/3) })
    }
  }

  scores.sort(function(a, b) {
    if (a.score < b.score) return -1;
    if (a.score > b.score) return 1;
    return 0;
  }).reverse()

  res.json(scores)
  await db.write()
})

// ---- POST HANDLERS ---- //
app.post('/terra_hook', async (req, res) => {
  try {
    let ref_id;
    switch (req.body.type) {
      case "auth":
        db.data.conv[req.body.user.user_id] = req.body.user.reference_id
        register_user(req.body.user.reference_id)
        break
      case "user_reauth":
        update_user(req.body.old_user.reference_id, req.body.new_user.reference_id)
        break
      case "activity":
        ref_id = req.body.user.reference_id ? req.body.user.reference_id : conv[req.body.user.user_id]
        decay_scores(ref_id)
        try {
          console.log(util.inspect(req.body, false, null, true))
          load_activity_data(ref_id, req.body.MET_data)
        } catch (e) {
          console.log("error: ", e);
        }
        check_scores(ref_id)
      case "sleep":
        ref_id = req.body.user.reference_id ? req.body.user.reference_id : conv[req.body.user.user_id]
        decay_scores(ref_id)
        process_sleep_data(ref_id, req.body.data[0].sleep_durations_data.asleep)
        check_scores(ref_id)
        break
      default:
        break
    }
  } catch (e) {
    console.log("err: ", e)
  }

  res.sendStatus(200)
  await db.write()
})

app.post('/send_action/:reference_id', async (req, res) => {
  console.log(util.inspect(req.body, false, null, true))
  try {
    decay_scores(req.params.reference_id)
    switch (req.body.type) {
      case "recycle":
        inc_recycle(req.params.reference_id)
        res.sendStatus(200)
        break
      case "journey":
        update_transport(req.params.reference_id, req.body.mode)
        res.sendStatus(200)
        break
      case "meal":
        update_meal(req.params.reference_id, req.body.category)
        res.sendStatus(200)
        break
      default:
        res.sendStatus(404)
        break
    }
    check_scores(req.params.reference_id)
  } catch (e) {
    console.log("err: ", e)
  }
  await db.write()
})

// ---- HELPER / HANDLERS ---- //
let decay_scores = (uid) => {
  let user = db.data[uid]
  let time = moment().unix()
  let delta = Math.max(time - db.data[uid].timestamp, 0)
  user.health = Math.max(user.health - delta * 0.0001, 0)
  user.planet = Math.max(user.planet - delta * 0.0001, 0)
  user.sleep = Math.max(user.sleep - delta * 0.0001, 0)
}

let check_scores = (uid) => {
  let user = db.data[uid]
  user.health = Math.min(user.health, 100)
  user.health = Math.max(user.health, 0)
  user.planet = Math.min(user.planet, 100)
  user.planet = Math.max(user.planet, 0)
  user.sleep = Math.min(user.sleep, 100)
  user.sleep = Math.max(user.sleep, 0)
}

let register_user = (uid) => {
  if (!(uid in db.data)) {
    let time = moment().unix()
    console.log(time)
    db.data[uid] = {
      "health": 50,
      "planet": 50,
      "sleep": 50,
      "timestamp": time
    }
    console.log(`🔧 Successfully registered ${color.magenta(uid)} w/ to the database!`)
    console.log(`${db.data.conv}`)
  } else {
    console.log(`🖇️ ${color.red(uid)} already exists! Ignoring...`)
  }
}

let update_user = (old_uid, new_uid) => {
  if (old_uid in db.data) {
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

let process_sleep_data = (uid, data) => {
  let light = data.duration_light_sleep_state_seconds
  let normal = data.duration_asleep_state_seconds
  let deep = data.duration_deep_sleep_state_seconds
  let REM = data.duration_REM_sleep_state_seconds
  let total = light + normal + deep + REM

  db.data[uid].sleep += (total / 3600) * 10
  db.data[uid].sleep = Math.min(100, db.data[uid].sleep)
}

let inc_recycle = (uid) => {
  db.data[uid].planet += 7
  console.log(db.data)
}

let update_transport = (uid, mode) => {
  let user = db.data[uid]

  switch (mode) {
    case "walk":
      user.planet += 10
      break
    case "cycle":
      user.planet += 10
      break
    case "bus":
      user.planet += 5
      break
    case "car":
      user.planet -= 10
    default:
      break
  }
}

let update_meal = (uid, method, category) => {
  let user = db.data[uid]
  switch (method) {
    case "self":
      user.planet += 10
      break;
    case "bought":
      user.planet -= 5
      break
    case "delivery":
      user.planet -= 15
      break
    default:
      break
  }

  switch (category) {
    case "red meat":
      user.planet -= 5
      break
    case "fish":
      user.planet -= 2
      break
    case "white meat":
      break
    case "vegetarian":
      user.planet += 5
      break
    default:
      break
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