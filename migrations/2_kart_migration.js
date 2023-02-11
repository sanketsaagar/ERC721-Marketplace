const Kart = artifacts.require("kart");
module.exports = function (deployer) {
  deployer.deploy(Kart);
};
