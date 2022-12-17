module.exports = {
  apps : [{
    name   : "AGH IOT Server",
    script : "./build/index.js",
    env: {
      "NODE_ENV": "production",
    }
  }]
}
