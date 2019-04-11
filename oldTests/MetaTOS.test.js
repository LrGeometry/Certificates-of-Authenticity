/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const MetaTOS = artifacts.require('MetaTOS');
const DummyToken = artifacts.require('DummyToken');

//const {
///  currentTime,
//} = require('../oldTests/utils');

let tokens;
let token;



const tokenURI = 'randomURI';

let nonce=0;
let hash;
const userPrivateKey = '0xb19f224e84b479aa309c71dd834a3910cbda288dda3f59ea2bd21412b9f4d708';
const userAddress = '0x8e2c2da5BF9F1320A92f795C8b4fBd722426896E';
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
  ipfshash:'Qmd286K6pohQcTKYqnS1YhWrCiS4gz7Xi34sdwMe9USZ7u',
  manufacturer:'gucci',
  factomEntryHash: 'FactomEntryHash',
  
  data: 'randomDataHash',
};
//console.log(testprovenance)
let updatedprovenance={
  
  hercid: 1,
  provenanceId:1,
  barId:2,
  serialnumber:3,
  price: 4,
  timestamp: currentTime(),
  weight:5,
  assay:'assay',
  ipfshash:'Qmd286K6pohQcTKYqnS1YhWrCiS4gz7Xi34sdwMe9USZ7u',
  manufacturer:'nike',
  factomEntryHash: 'FactomEntryHash',
  
  data: 'newData',

}
contract('MetaTOS', (accounts) => {
  it('Should deploy an instance of the DummyToken contract', () => DummyToken.deployed()
    .then((instance) => {
      token = instance;
    }));

  it('Should deploy an instance of the MetaCOO contract', () => MetaTOS.deployed(token.address)
    .then((instance) => {
      tos = instance;
    }));

  it('Should get some free Dummy Tokens', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should give COO contract the allowance', () => token.approve(
    tos.address,
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should check the nonce for account 1', () => tos.nonces(accounts[1])
    .then((res) => {
      assert.equal(res.toNumber(), 0, 'Account 1 nonce is wrong');
      nonce = res.toNumber();
    }));

  /**const testprovenance = {
  
  hercid: 0,
  provenanceId:1,
  barId:1,
  serialnumber:2,
  price: 200,
  timestamp: currentTime(),
  weight:300,
  assay:'assay placeholder',
  ipfshash:'0xbca7553fb066aa3b550ad7f34ee843748eed2e9a899119d94875f80db8eb903b',
  manufacturer:'gucci',
  factomEntryHash: 'FactomEntryHash',
  
  data: 'randomDataHash',
}; */

  it('Should get the metaCreateCertificate hash', () => tos.metaCreateprovenanceHash(
    testprovenance,
    tokenURI,
    nonce,
  )
    .then((res) => {
      const metaHash = web3.utils.soliditySha3(
        tos.address,
        "metaCreateprovenance",
        testprovenance.hercid,
        testprovenance.provenanceId,
        testprovenance.barId,
        testprovenance.serialnumber,
        testprovenance.price,
        testprovenance.timestamp,
        testprovenance.weight,
        testprovenance.assay,
        testprovenance.manufacturer,
        
        testprovenance.factomEntryHash,
        testprovenance.data,
        tokenURI,
        nonce
      );

      assert.equal(res, metaHash, 'Hash is wrong');
      hash = res;
    }));

  it('Should check the signer of the hash', () => tos.getSigner(
    hash,
    web3.eth.accounts.sign(hash, userPrivateKey).signature,
  )
    .then((res) => {
      assert.equal(res, userAddress, 'Signer is wrong');
    }));

  it('Should create a new certificate using metaCreateCertificate', () => tos.metaCreateprovenance(
    web3.eth.accounts.sign(hash, userPrivateKey).signature,
    testprovenance,
    tokenURI,
    nonce,
  ));
  
  it('Should check user balance', () => tos.balanceOf(userAddress)
    .then((balance) => {
      assert.equal(balance.toNumber(), 1, 'User balance is wrong');
    }));
 

   it('Should log nonces',() => tos.nonces(userAddress).then(res=>{console.log(res)})
  )
  it('Should get the metaUpdateCertificate hash',() => tos.metaUpdateprovenanceHash(
    [1,1,2,3,4,5],['assay','Qmd286K6pohQcTKYqnS1YhWrCiS4gz7Xi34sdwMe9USZ7u','nike','FactomEntryHash','newData'],
    1,
  )
    .then((res) => {
     
     
      const metaHash = web3.utils.soliditySha3( 
        tos.address,
        "metaUpdateprovenance",
        updatedprovenance.hercid,
        updatedprovenance.provenanceId,
        updatedprovenance.barId,
        updatedprovenance.serialnumber,
        updatedprovenance.price,
        updatedprovenance.weight,
        updatedprovenance.assay,
        updatedprovenance.ipfshash,
        updatedprovenance.manufacturer,       
        updatedprovenance.factomEntryHash,
        updatedprovenance.data,
       1,
      );

      assert.equal(res, metaHash, 'Hash is wrong');
      hash = res;
    }));

  it('Should update certificate 0 using metaUpdateCertificate', () => tos.metaUpdateprovenance(
    web3.eth.accounts.sign(hash, userPrivateKey).signature,
    [1,1,2,3,4,5],['assay','Qmd286K6pohQcTKYqnS1YhWrCiS4gz7Xi34sdwMe9USZ7u','nike','FactomEntryHash','newData'],
    nonce+1
  ));
  
  it('Should get the metaTransfer hash', () => tos.metaTransferHash(
    accounts[1],
    1,
    nonce + 2,
  )
    .then((res) => {
      const metaHash = web3.utils.soliditySha3(
        tos.address,
        'metaTransfer',
        accounts[1],
        1,
        nonce + 2,
      );

      assert.equal(res, metaHash, 'Hash is wrong');
      hash = res;
    }));

  it('Should transfer a token using metaTransfer', () => tos.metaTransfer(
    web3.eth.accounts.sign(hash, userPrivateKey).signature,
    accounts[1],
    1,
    nonce + 2,
  ));

  it('Should check the new owner of token 0', () => tos.ownerOf(1)
    .then((owner) => {
      assert.equal(owner, accounts[1], 'Token 0 owner is wrong');
    }));

  it('Should get the metaSetApprovalForAll hash', () => tos.metaSetApprovalForAllHash(
    accounts[2],
    true,
    nonce + 3,
  )
    .then((res) => {
      const metaHash = web3.utils.soliditySha3(
        tos.address,
        'metaSetApprovalForAll',
        accounts[2],
        true,
        nonce + 3,
      );

      assert.equal(res, metaHash, 'Hash is wrong');
      hash = res;
    }));

  it('Should set an approval for all using metaSetApprovalForAll', () => tos.metaSetApprovalForAll(
    web3.eth.accounts.sign(hash, userPrivateKey).signature,
    accounts[2],
    true,
    nonce + 3,
  ));

  it('Should check if account 2 is approved for all the tokens of the user', () => tos.isApprovedForAll(
    userAddress,
    accounts[2],
  )
    .then((res) => {
      assert.equal(res, true, 'Allowance is wrong');
    }));
});
