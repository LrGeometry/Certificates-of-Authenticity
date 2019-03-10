/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const DummyToken = artifacts.require('DummyToken');
const MetaCOO = artifacts.require('MetaCOO');
const MetaMarketplace = artifacts.require('MetaMarketplace');

const {
  currentTime,
  getFutureDate,
} = require('./utils');

let token;
let coo;
let marketplace;

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

const newSale = {
  certificateId: 0,
  price: 10,
  expiresAt: getFutureDate(6),
};

const nonces = {
  marketplace: [0, 0],
  coo: [0, 0],
};

let hash;

const privateKeys = [
  '0xb19f224e84b479aa309c71dd834a3910cbda288dda3f59ea2bd21412b9f4d708',
  '0x8139704eb91f4214ff5d60342f039e9d49b174d5a26cd2a2fa9db9ea023b11c1',
];

contract('Marketplace', (accounts) => {
  it('Should deploy an instance of the DummyToken contract', () => DummyToken.deployed()
    .then((instance) => {
      token = instance;
    }));

  it('Should deploy an instance of the COO contract', () => MetaCOO.deployed(token.address)
    .then((instance) => {
      coo = instance;
    }));

  it('Should deploy an instance of the Marketplace contract', () => MetaMarketplace.new(token.address, coo.address)
    .then((instance) => {
      marketplace = instance;
    }));

  it('Should get some free Dummy Tokens - Account 1', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should get some free Dummy Tokens - Account 2', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[2],
    },
  ));

  it('Should give COO contract allowance - Account 1', () => token.approve(
    coo.address,
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should give COO contract allowance - Account 2', () => token.approve(
    coo.address,
    web3.utils.toWei('100'), {
      from: accounts[2],
    },
  ));

  it('Should give the marketplace allowance - Account 2', () => token.approve(
    marketplace.address,
    web3.utils.toWei('100'), {
      from: accounts[2],
    },
  ));

  it('Should check the nonce for account 1', () => coo.nonces(accounts[1])
    .then((res) => {
      assert.equal(res.toNumber(), 0, 'Account 1 nonce is wrong');
      nonces.coo[0] = res;
    }));

  it('Should get the metaCreateCertificate hash', () => coo.metaCreateCertificateHash(
    testCertificate.assetId,
    testCertificate.name,
    testCertificate.label,
    testCertificate.price,
    testCertificate.timestamp,
    testCertificate.factomEntryHash,
    testCertificate.anotherEncryptionKey,
    testCertificate.data,
    nonces.coo[0],
  )
    .then((res) => {
      hash = res;
    }));

  it('Should create a new certificate using metaCreateCertificate', () => coo.metaCreateCertificate(
    web3.eth.accounts.sign(hash, privateKeys[0]).signature,
    testCertificate,
    nonces.coo[0],
  )
    .then(() => {
      nonces.coo[0] += 1;
    }));

  it('Should get the hash for the metaSetApprovalForAll function', () => coo.metaSetApprovalForAllHash(
    marketplace.address,
    true,
    nonces.coo[0],
  )
    .then((res) => {
      hash = res;
    }));

  it('Should give the Marketplace allowance', () => coo.metaSetApprovalForAll(
    web3.eth.accounts.sign(hash, privateKeys[0]).signature,
    marketplace.address,
    true,
    nonces.coo[0],
  ));

  it('Should get the metaCreateSaleHash', () => marketplace.metaCreateSaleHash(
    newSale.certificateId,
    newSale.price,
    newSale.expiresAt,
    nonces.marketplace[0],
  )
    .then((res) => {
      hash = res;
    }));

  it('Should create a new sale using metaCreateSale', () => marketplace.metaCreateSale(
    web3.eth.accounts.sign(hash, privateKeys[0]).signature,
    newSale.certificateId,
    newSale.price,
    newSale.expiresAt,
    nonces.marketplace[0],
  )
    .then(() => {
      nonces.marketplace[0] += 1;
    }));

  it('Should get the metaExecuteSale hash', () => marketplace.metaExecuteSaleHash(
    0,
    nonces.marketplace[1],
  )
    .then((res) => {
      hash = res;
    }));

  it('Should execute buy with metaExecuteSale', () => marketplace.metaExecuteSale(
    web3.eth.accounts.sign(hash, privateKeys[1]).signature,
    0,
    nonces.marketplace[1],
  ));

  it('Should check the owner of certificate 0', () => coo.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[2], 'Owner is wrong');
    }));
});
