/* eslint-env node */
/* global artifacts */

const COO = artifacts.require('COO');
const MetaCOO = artifacts.require('MetaCOO');
const DummyToken = artifacts.require('test/DummyToken');
const Marketplace = artifacts.require('Marketplace');
const MetaMarketplace = artifacts.require('MetaMarketplace');

function deployContracts(deployer, network) {
  if (network === 'development') {
    deployer.deploy(DummyToken)
      .then(() => deployer.deploy(COO, DummyToken.address))
      .then(() => deployer.deploy(MetaCOO, DummyToken.address))
      .then(() => deployer.deploy(Marketplace, DummyToken.address, MetaCOO.address))
      .then(() => deployer.deploy(MetaMarketplace, DummyToken.address, MetaCOO.address));
  } else if (network === 'ropsten') {
    deployer.deploy(DummyToken)
      .then(() => deployer.deploy(MetaCOO, DummyToken.address))
      .then(() => deployer.deploy(MetaMarketplace, DummyToken.address, MetaCOO.address));
  }
}

module.exports = deployContracts;
