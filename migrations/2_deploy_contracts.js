/* eslint-env node */
/* global artifacts */
//const DummyToken = artifacts.require('test/DummyToken');
//const TOS=artifacts.require('TOS.sol')

const ERC1155=artifacts.require('HERC1155.sol')
const NFT=artifacts.require('NFTCreator');

function deployContracts(deployer, network) {

  deployer.then(async () => {
    if(network=='development'){
    let DT=await deployer.deploy(DummyToken)
   // await deployer.deploy(PO)
   // await deployer.deploy(TOS,DT.address)
   // await deployer.deploy(PR)
    await deployer.deploy(BLT)
    }
    if(network==='mainnet'){
      console.log(network)
      await deployer.deploy(Meta,'0x6251583e7D997DF3604bc73B9779196e94A090Ce')
    }
      //let DT=await deployer.deploy(DummyToken)
      //await deployer.deploy(TOS,DT.address)
      
      let E=await deployer.deploy(ERC1155)
      await deployer.deploy(NFT,1,E.address)
   
})
}
module.exports = deployContracts;
