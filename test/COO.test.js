/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const COO = artifacts.require('COO');
const DummyToken = artifacts.require('DummyToken');

let coo;
let token;

function currentTime() {
  return Math.round(Date.now() / 1000);
}

const testCertificate = {
  assetId: 0,
  name: 'Name',
  label: 'Label',
  price: 200,
  timestamp: currentTime(),
  factomEntryHash: 'FactomEntryHash',
  anotherEncryptionKey: 'AnotherEncryptionKey',
  data: 'randomDataHash',
};

const tokenURI = 'randomURI';

contract('COO', (accounts) => {
  it('Should deploy an instance of the DummyToken contract', () => DummyToken.deployed()
    .then((instance) => {
      token = instance;
    }));

  it('Should deploy an instance of the COO contract', () => COO.deployed(token.address)
    .then((instance) => {
      coo = instance;
    }));

  it('Should get some free Dummy Tokens', () => token.claimFreeTokens(
    web3.utils.toWei('100'),
  ));

  it('Should give COO contract the allowance', () => token.approve(
    coo.address,
    web3.utils.toWei('100'),
  ));

  it('Should create a new certificate', () => coo.createCertificate(testCertificate, tokenURI));

  it('Should get the information of certificate 0', () => coo.getCertificate(0)
    .then((certificate) => {
      assert.containsAllKeys(certificate, testCertificate, 'Certificate is wrong');
    }));

  it('Should NOT get the information of certificate 0', () => coo.getCertificate(0, {
    from: accounts[1],
  })
    .then(() => {
    })
    .catch((error) => {
      assert.equal(error.message.includes('revert'), true, 'A revert error was supposed to happen here');
    }));

  it('Should update the certificate 0', () => coo.updateCertificate(
    0,
    testCertificate.name,
    testCertificate.label,
    2000,
    testCertificate.factomEntryHash,
    testCertificate.anotherEncryptionKey,
    testCertificate.data,
  ));

  it('Should check the owner of certificate 0', () => coo.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[0], 'Owner is wrong');
    }));

  it('Should check the balance of account 0', () => coo.balanceOf(accounts[0])
    .then((balance) => {
      assert.equal(balance, 1, 'Balance is wrong');
    }));

  it('Should check the token owned by account 0 at index 0', () => coo.tokenOfOwnerByIndex(
    accounts[0],
    0,
  )
    .then((tokenId) => {
      assert.equal(tokenId, 0, 'Token id is wrong');
    }));

  it('Should transfer the certificate 0', () => coo.transferFrom(accounts[0], accounts[1], 0));

  it('Should check the owner of certificate 0', () => coo.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[1], 'Owner is wrong');
    }));
});
