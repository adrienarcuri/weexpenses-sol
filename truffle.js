// Allows us to use ES6 in our migrations and tests.
require('babel-register')({
  ignore: /node_modules\/(?!zeppelin-solidity\/test\/helpers)/
});
require('babel-polyfill')
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*' // Match any network id
    }
  },
  coverage: {
    host: "localhost",
    port: 8555,
    network_id: "*",
    gas: 0xffffffff
  }
}