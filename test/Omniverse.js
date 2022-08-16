const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers")
const { expect } = require('chai')

describe('Omniverse Contract', () => {
  const deployContractFixture = async () => {
    const [wallet, walletTo] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory('CustomERC721A')
    const contract = await Contract.deploy();

    return { contract, wallet, walletTo }
  }

  describe('Deployment', () => {
    it('Should set the right owner', async () => {
      const { contract, wallet } = await loadFixture(deployContractFixture)
      expect(await contract.owner()).to.equal(wallet.address)
    })
  })
})