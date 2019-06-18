/* eslint-env node */
/* global artifacts */
const DummyToken = artifacts.require('test/DummyToken');
//const TOS=artifacts.require('TOS.sol')
const PO=artifacts.require('POToken.sol')
const PR=artifacts.require('PRToken.sol')
const BLT=artifacts.require('BLToken.sol')
const Meta=artifacts.require('MetaTOS.sol')
const Market=artifacts.require('MetaMarketplace.sol')
const RFI=artifacts.require('RFIToken.sol')
const RFQ=artifacts.require('RFQToken.sol')
const RFP=artifacts.require('RFPToken.sol')

function deployContracts(deployer, network) {
 console.log(network)
  deployer.then(async () => {
    if(network==='development'){
    let DT=await deployer.deploy(DummyToken)
    await deployer.deploy(PO)
    await deployer.deploy(TOS,DT.address)
    await deployer.deploy(PR)
    await deployer.deploy(BLT)
    }
    if(network==='mainnet'){
      console.log(network)
      //await deployer.deploy(Meta,'0x6251583e7D997DF3604bc73B9779196e94A090Ce')
      //await deployer.deploy(Market,'0x6251583e7D997DF3604bc73B9779196e94A090Ce','0xe1b0FCA090EfA8588aFdB96973A540760F90A8A0')
      await deployer.deploy(RFP)
    }
    if(network==='ropsten'){
      let DT=await deployer.deploy(DummyToken)
      let TOS=await deployer.deploy(TOS,DT.address)
      await deployer.deploy(Market,DT.address,TOS.address) 
      /** await deployer.deploy(RFI)
      let Q=await deployer.deploy(RFQ)
      
      await deployer.deploy(PO,Q.address)
      await deployer.deploy(BLT)
      await deployer.deploy(PR)
      **/
    }
    
 })
}

module.exports = deployContracts;
