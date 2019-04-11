/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const tos = artifacts.require('TOS');
const DummyToken = artifacts.require('DummyToken');

let TOS;
let token;
/**
 *  
 * uint256 hercid;
    uint256 provenanceId;
    uint256 barId;
    uint256 serialnumber;

        uint256 price;
        uint256 timestamp;
        uint256 weight;
        string  assay;
        string ipfshash;
        string  manufacturer;
        string factomEntryHash;
       
        string data;
 */
function currentTime() {
  return Math.round(Date.now() / 1000);
}

const testprovenance = {
  
  hercid: 0,
  provenanceId:1,
  barId:1,
  serialnumber:2,
  price: 200,
  timestamp: currentTime(),
  weight:300,
  assay:'assay placeholder',
  ipfshash:'0xsdfaweifhifehalfhkwehfilawhfuihweakuhwh',
  manufacturer:'gucci',
  factomEntryHash: 'FactomEntryHash',
  
  data: 'randomDataHash',
};
console.log(testprovenance)
let updatedprovenance={
  
  hercid: 1,
  provenanceId:1,
  barId:2,
  serialnumber:3,
  price: 4,
  timestamp: currentTime(),
  weight:5,
  assay:'assay',
  ipfshash:'0x2384923479270jsjdoajf3434ejl',
  manufacturer:'nike',
  factomEntryHash: 'FactomEntryHash',
  
  data: 'newData',

}
const tokenURI = 'randomURI';

contract('TOS', (accounts) => {
  it('Should deploy an instance of the DummyToken contract', () => DummyToken.deployed()
    .then((instance) => {
      token = instance;
    }));

  it('Should deploy an instance of the TOS contract', () => tos.deployed(token.address)
    .then((instance) => {
      TOS = instance;
    }));

  it('Should get some free Dummy Tokens', () => token.claimFreeTokens(
    web3.utils.toWei('100'),
  ));

  it('Should give TOS contract the allowance', () => token.approve(
    TOS.address,
    web3.utils.toWei('100'),
  ));

  it('Should create a new provenance', () => TOS.createprovenance(testprovenance, tokenURI));

  it('Should get the information of provenance 0', () => TOS.getprovenance(1)
    .then((provenance) => {
      console.log(provenance)
      assert.containsAllKeys(provenance, testprovenance, 'provenance is wrong');
    }));

  it('Should NOT get the information of provenance 0', () => TOS.getprovenance(0, {
    from: accounts[1],
  })
    .then(() => {
    })
    .catch((error) => {
      assert.equal(error.message.includes('revert'), true, 'A revert error was supposed to happen here');
    })
   
    )

  

  it('Should update the provenance', () => TOS.updateprovenance(
   [1,1,2,3,4,5],['assay','0x2384923479270jsjdoajf3434ejl','nike','FactomEntryHash','newData'],{from:accounts[0]}
  ));

  it('Should get the information of provenance 0', () => TOS.getprovenance(1)
  .then((provenance) => {
    console.log(provenance)
    assert.containsAllKeys(provenance, updatedprovenance, 'provenance is wrong');
  }));
 

  it('Should check the balance of account 0', () => TOS.balanceOf(accounts[0])
    .then((balance) => {
      assert.equal(balance, 1, 'Balance is wrong');
    }));

  it('Should check the token owned by account 0 at index 0', () => TOS.tokenOfOwnerByIndex(
    accounts[0],
    0,
  )
    .then((tokenId) => {
      assert.equal(tokenId, 1, 'Token id is wrong');
    }));

  it('Should transfer the provenance 0', () => TOS.transferFrom(accounts[0], accounts[1], 1));

  it('Should check the owner of provenance 0', () => TOS.ownerOf(1)
    .then((owner) => {
      assert.equal(owner, accounts[1], 'Owner is wrong');
    }));
});
