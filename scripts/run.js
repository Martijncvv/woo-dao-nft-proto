const main = async () => {
	const [owner, person_2, person_3] = await hre.ethers.getSigners()

	const nftContractFactory = await hre.ethers.getContractFactory(
		'wooDaoNftProto'
	)
	const nftContract = await nftContractFactory.deploy()
	await nftContract.deployed()
	console.log('WOO-DAO-NFT deployed to:', nftContract.address)

	let mintTx_1 = await nftContract.mintNft(
		person_2.address,
		'https://jsonkeeper.com/b/H1IK'
	)
	await mintTx_1.wait()

	let mintTx_2 = await nftContract.mintNft(
		person_3.address,
		'https://jsonkeeper.com/b/JZUW'
	)
	await mintTx_2.wait()
}

const runMain = async () => {
	try {
		await main()
		process.exit(0)
	} catch (error) {
		console.log(error)
		process.exit(1)
	}
}

runMain()

// {
//     "name": "WOODao Token",
//     "description": "Token to show WOO DAO voting weight",
//     "image": "https://lh3.googleusercontent.com/9f2eQe8HNQ5cRBwJqCcmsmE4bQFUhrwDacZiCjk16Knl-UyqSCepAj3FQs1m0wfBzYmv_E4Ux9g9gptam3jhMhnJKhwgNUKXCztue0I=w600",
//     "WOOX-tier": 1,
//     "WOOFi-tier": 2
// }
// https://jsonkeeper.com/b/H1IK

// {
//     "name": "WOODao Token",
//     "description": "Token to show WOO DAO voting weight",
//     "image": "https://lh3.googleusercontent.com/P_O5PvVGov06j6BxxRxkeufWit9gg663TT9-S-i4M05glCjXRNduE0RYd5dqfsThGc5BJq6CbzHeMdEk1zVvBa1ZpMff2tIefF31D4s=w600",
//     "WOOX-tier": 1,
//     "WOOFi-tier": 4
// }
// https://jsonkeeper.com/b/JZUW
