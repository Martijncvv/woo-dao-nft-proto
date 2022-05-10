require('@nomiclabs/hardhat-waffle')
require('dotenv').config({ path: '.env' })
require('hardhat-gas-reporter')

module.exports = {
	solidity: '0.8.4',
	networks: {
		rinkeby: {
			url: process.env.ALCHEMY_API_URL,
			accounts: [process.env.RINKEBY_PRIVATE_KEY],
		},
	},
}
