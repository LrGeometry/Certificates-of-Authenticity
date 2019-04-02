/* eslint-env node */
/* global artifacts */


const PO=artifacts.require('POToken.sol')
const PR=artifacts.require('PRToken.sol')
function deployContracts(deployer, network) {

  deployer.then(async () => {
   
  await deployer.deploy(PO)
  await deployer.deploy(PR)
 })
}

module.exports = deployContracts;
