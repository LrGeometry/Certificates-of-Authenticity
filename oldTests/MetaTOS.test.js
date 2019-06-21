/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const MetaTOS = artifacts.require('MetaTOS');
const DummyToken = artifacts.require('HERC1155');

//const {
///  currentTime,
//} = require('../oldTests/utils');

let tokens;
let token;



const tokenURI = 'randomURI';

let nonce=0;
let hash;
const userPrivateKey = '0x2184b8c210c5839de74a837ada675d154c152f4033193b9b9a6c2c46d286c364';
const userAddress = '0xEfA2bc4D954E233961A7340c8f421dCbE863Ec4c';
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

  it('Should deploy an instance of the MetaCOO contract', () => MetaTOS.deployed(token.address,1)
    .then((instance) => {
      tos = instance;
    }));
// create(uint256 _initialSupply, string memory _uri,string memory name,string memory symbol)
  it('Should get some free Dummy Tokens', () => token.create( web3.utils.toWei('100'),"data","Hercules","HERC"  ,{
      from: accounts[0],
    },
  ));
  it('User should have tokens', async function(){
     console.log(await token.balanceOf(accounts[0],1) + "balance")
  })
  //allowance(address _owner, address _spender, uint256 _id)
 
//address _spender, uint256 _id, uint256 _currentValue, uint256 _value)
  it('Should give COO contract the allowance', () => token.approve(
    tos.address,1,0,
    1000000, {
      from: accounts[0],
    },
  ));

  it('User should have allowance', async function(){
    console.log(await token.allowance(accounts[0], tos.address,1) +"allowance")
  });



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
  
  it('Should check user balance', () => token.balanceOf(userAddress,2)
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
  
  })
