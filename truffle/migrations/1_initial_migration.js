const Migrations = artifacts.require("Migrations");
var MediPure = artifacts.require("./MediPure.sol");
var Supplier = artifacts.require("./Supplier.sol");
var Manufacturer = artifacts.require("./Manufacturer.sol");
var WholeSaler = artifacts.require("./WholeSaler.sol");
var Distributer = artifacts.require("./Distributer.sol");
var Pharma = artifacts.require("./Pharma.sol");
var Transporter = artifacts.require("./Transporter.sol");
var Info = artifacts.require("./Info.sol");

module.exports = function (deployer) {
  deployer.deploy(Migrations);

  deployer.deploy(MediPure)
  .then(function() {
    return deployer.deploy(Supplier, MediPure.address);
  })
  .then(function() {
    return deployer.deploy(Manufacturer, MediPure.address);
  })
  .then(function() {
    return deployer.deploy(WholeSaler, MediPure.address);
  })
  .then(function() {
    return deployer.deploy(Distributer, MediPure.address,WholeSaler.address);
  })
  .then(function() {
    return deployer.deploy(Pharma, MediPure.address,Distributer.address);
  })
  .then(function() {
    return deployer.deploy(Transporter, MediPure.address,WholeSaler.address,Distributer.address);
  })
  .then(function() {
    return deployer.deploy(Info);
  })

};
