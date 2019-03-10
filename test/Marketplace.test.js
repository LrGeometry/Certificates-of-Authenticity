/* eslint-env mocha */
/* global artifacts, contract, assert, web3 */

const DummyToken = artifacts.require('DummyToken');
const COO = artifacts.require('COO');
const Marketplace = artifacts.require('Marketplace');

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

contract('Marketplace', (accounts) => {
  it('Should deploy an instance of the DummyToken contract', () => DummyToken.deployed()
    .then((instance) => {
      token = instance;
    }));

  it('Should deploy an instance of the COO contract', () => COO.deployed(token.address)
    .then((instance) => {
      coo = instance;
    }));

  it('Should deploy an instance of the Marketplace contract', () => Marketplace.new(token.address, coo.address)
    .then((instance) => {
      marketplace = instance;
    }));

  it('Should check the address of the DummyToken in the Marketplace contract', () => marketplace.tokenContractAddress()
    .then((address) => {
      assert.equal(address, token.address, 'Token contract address is wrong');
    }));

  it('Should check the address of the COO in the Marketplace contract', () => marketplace.cooContractAddress()
    .then((address) => {
      assert.equal(address, coo.address, 'COO contract address is wrong');
    }));

  it('Should get some free Dummy Tokens from - Account 1', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should get some free Dummy Tokens from - Account 2', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[2],
    },
  ));

  it('Should get some free Dummy Tokens from - Account 3', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[3],
    },
  ));

  it('Should get some free Dummy Tokens from - Account 4', () => token.claimFreeTokens(
    web3.utils.toWei('100'), {
      from: accounts[4],
    },
  ));

  it('Should give COO contract the allowance - Account 1', () => token.approve(
    coo.address,
    web3.utils.toWei('100'), {
      from: accounts[1],
    },
  ));

  it('Should create a new certificate', () => coo.createCertificate(testCertificate, {
    from: accounts[1],
  }));

  it('Should allow the marketplace contract to manipulate certificate 0', () => coo.approve(marketplace.address, 0, {
    from: accounts[1],
  }));

  it('Should create a new order for certificate 0', () => marketplace.createSale(
    0,
    10,
    getFutureDate(6), {
      from: accounts[1],
    },
  ));

  it('Should allow marketplace contract to manipulate account 2 funds', () => token.approve(marketplace.address, 10, {
    from: accounts[2],
  }));

  it('Should execute order 0', () => marketplace.executeSale(0, {
    from: accounts[2],
  }));

  it('Should check the owner of certificate 0', () => coo.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[2], 'Owner is wrong');
    }));

  it('Should create another new certificate from account 1', () => coo.createCertificate(testCertificate, {
    from: accounts[1],
  }));

  it('Should allow the marketplace contract to manipulate certificate 1', () => coo.approve(marketplace.address, 1, {
    from: accounts[1],
  }));

  it('Should create a new auction for certificate 1', () => marketplace.createAuction(
    1,
    10,
    getFutureDate(6), {
      from: accounts[1],
    },
  ));

  it('Should allow marketplace contract to manipulate account 3 funds', () => token.approve(marketplace.address, 10, {
    from: accounts[3],
  }));

  it('Should allow marketplace contract to manipulate account 4 funds', () => token.approve(marketplace.address, 20, {
    from: accounts[4],
  }));

  it('Should execute auction 0', () => marketplace.executeAuction(0, 10, {
    from: accounts[3],
  }));

  it('Should execute auction 0', () => marketplace.executeAuction(0, 20, {
    from: accounts[4],
  }));

  it('Should time travel 12 hours', () => {
    const jsonrpc = '2.0';
    const id = 0;
    const method = 'evm_increaseTime';

    return new Promise((resolve, reject) => {
      web3.currentProvider.send({
        jsonrpc,
        method,
        params: [12 * 60 * 60],
        id,
      }, (err, result) => {
        if (err) { return reject(err); }
        return resolve(result);
      });
    });
  });

  it('Should complete the auction 0', () => marketplace.completeAuction(0, {
    from: accounts[4],
  }));

  it('Should check the owner of certificate 1', () => coo.ownerOf(1)
    .then((owner) => {
      assert.equal(owner, accounts[4], 'Owner is wrong');
    }));
});
