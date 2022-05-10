const main = async () => {
	const [person_1, person_2, person_3] = await hre.ethers.getSigners()

	const nftContractFactory = await hre.ethers.getContractFactory(
		'WooDaoNftProto_1'
	)
	const nftContract = await nftContractFactory.connect(person_1).deploy()
	await nftContract.deployed()
	console.log('WOO-DAO-NFT deployed to:', nftContract.address)

	// ENABLE TRANSFER
	let enable_1_transfer = await nftContract.enableTransfers()
	await enable_1_transfer.wait()
	console.log('TRANSFERS ENABLED')

	// MINT
	let mintTx_0 = await nftContract.mintNft(
		person_2.address,
		'https://jsonkeeper.com/b/H1IK'
	)
	await mintTx_0.wait()

	let mintTx_1 = await nftContract.mintNft(
		person_2.address,
		'https://jsonkeeper.com/b/JZUW'
	)
	await mintTx_1.wait()

	let mintTx_2 = await nftContract.mintNft(
		person_2.address,
		'https://jsonkeeper.com/b/JZUW'
	)
	await mintTx_2.wait()

	let balanceOf_person_1 = await nftContract.balanceOf(person_1.address)
	let balanceOf_person_2 = await nftContract.balanceOf(person_2.address)
	let balanceOf_person_3 = await nftContract.balanceOf(person_3.address)
	console.log('   balanceOf_person_1: ', balanceOf_person_1)
	console.log('   balanceOf_person_2: ', balanceOf_person_2)
	console.log('   balanceOf_person_3: ', balanceOf_person_3)

	// TRANSFER
	let transfer_id_0 = await nftContract
		.connect(person_2)
		.transferFrom(person_2.address, person_3.address, 0)
	await transfer_id_0.wait()
	console.log('- Transfer: person_2 -> person_3 - NFT ID 0')

	// BALANCES
	balanceOf_person_1 = await nftContract.balanceOf(person_1.address)
	balanceOf_person_2 = await nftContract.balanceOf(person_2.address)
	balanceOf_person_3 = await nftContract.balanceOf(person_3.address)
	console.log('   balanceOf_person_1: ', balanceOf_person_1)
	console.log('   balanceOf_person_2: ', balanceOf_person_2)
	console.log('   balanceOf_person_3: ', balanceOf_person_3)

	// PAUSE CONTRACT
	// let pause_contract_1 = await nftContract.pause()
	// await pause_contract_1.wait()
	// console.log('CONTRACT PAUSED')

	// DISABLE TRANSFER
	let disable_1_transfer = await nftContract.disableTransfers()
	await disable_1_transfer.wait()
	console.log('TRANSFERS DISABLED')

	// MINT
	// let mintTx_3 = await nftContract.mintNft(
	// 	person_2.address,
	// 	'https://jsonkeeper.com/b/H1IA'
	// )
	// await mintTx_3.wait()

	// // BALANCES
	// balanceOf_person_1 = await nftContract.balanceOf(person_1.address)
	// balanceOf_person_2 = await nftContract.balanceOf(person_2.address)
	// balanceOf_person_3 = await nftContract.balanceOf(person_3.address)
	// console.log('   balanceOf_person_1: ', balanceOf_person_1)
	// console.log('   balanceOf_person_2: ', balanceOf_person_2)
	// console.log('   balanceOf_person_3: ', balanceOf_person_3)

	// // TRANSFER
	// let transfer_id_1 = await nftContract
	// 	.connect(person_2)
	// 	.transferFrom(person_2.address, person_3.address, 1)
	// await transfer_id_1.wait()
	// console.log('- Transfer: person_2 -> person_3 - NFT ID 1')

	// // BALANCES
	// balanceOf_person_1 = await nftContract.balanceOf(person_1.address)
	// balanceOf_person_2 = await nftContract.balanceOf(person_2.address)
	// balanceOf_person_3 = await nftContract.balanceOf(person_3.address)
	// console.log('   balanceOf_person_1: ', balanceOf_person_1)
	// console.log('   balanceOf_person_2: ', balanceOf_person_2)
	// console.log('   balanceOf_person_3: ', balanceOf_person_3)
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
