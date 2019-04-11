/* eslint-env node */
/* global artifacts */
const DummyToken = artifacts.require('test/DummyToken');
const TOS=artifacts.require('TOS.sol')
const PO=artifacts.require('POToken.sol')
const PR=artifacts.require('PRToken.sol')
const BLT=artifacts.require('BLToken.sol')
const Meta=artifacts.require('MetaTOS.sol')

const RFI=artifacts.require('RFIToken.sol')
const RFQ=artifacts.require('RFQToken.sol')
const RFP=artifacts.require('RFPToken.sol')

function deployContracts(deployer, network) {

  deployer.then(async () => {
    if(network=='development'){
    let DT=await deployer.deploy(DummyToken)
    await deployer.deploy(PO)
    await deployer.deploy(TOS,DT.address)
    await deployer.deploy(PR)
    await deployer.deploy(BLT)
    }
    if(network==='mainnet'){
      console.log(network)
      await deployer.deploy(Meta,'0x6251583e7D997DF3604bc73B9779196e94A090Ce')
    }
    let DT=await deployer.deploy(DummyToken)
    await deployer.deploy(TOS,DT.address)
    await deployer.deploy(Meta,DT.address) 
    await deployer.deploy(RFI)
    await deployer.deploy(RFQ)
    await deployer.deploy(RFP)
 })
}

module.exports = deployContracts;
