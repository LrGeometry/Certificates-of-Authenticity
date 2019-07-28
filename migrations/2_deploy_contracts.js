/* eslint-env node */
/* global artifacts */
//const DummyToken = artifacts.require('test/DummyToken');
//const TOS=artifacts.require('TOS.sol')

const ERC1155=artifacts.require('HERC115520.sol')
const Meta=artifacts.require('MetaHERC1155.sol')
const NFT=artifacts.require('NFTCreator');
const FUTURIST=artifacts.require('Futurist')
function deployContracts(deployer, network) {

  deployer.then(async () => {
    if(network=='development'){
   
   // await deployer.deploy(PO)
   // await deployer.deploy(TOS,DT.address)
   // await deployer.deploy(PR)
   let E=await deployer.deploy(ERC1155)
   await deployer.deploy(NFT,E.address,1)
    }
    if(network==='mainnet'){
     
    }
      //let DT=await deployer.deploy(DummyToken)
      //await deployer.deploy(TOS,DT.address)
      
      let E=await deployer.deploy(ERC1155)
      await deployer.deploy(NFT,E.address,1)
      await deployer.deploy(FUTURIST)
      
   
})
}
module.exports = deployContracts;
