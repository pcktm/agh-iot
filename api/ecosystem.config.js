module.exports = {
  apps : [{
    name   : "AGH IOT Server",
    script : "./dist/src/index.js",
    env: {
      "NODE_ENV": "production",
    }
  }]
}
