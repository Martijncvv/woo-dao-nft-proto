const main = async () => {
	const nftContractFactory = await hre.ethers.getContractFactory(
		'WooDaoNftProto_1'
	)
	const nftContract = await nftContractFactory.deploy()
	await nftContract.deployed()
	console.log('WOO-DAO-NFT deployed to:', nftContract.address)

	let mintTx_1 = await nftContract.mintNft(
		'0x56d8bf89371ba9ed001a27ac7a1fab640afe4f91',
		'https://jsonkeeper.com/b/55WK'
	)
	await mintTx_1.wait()
	console.log('Minted NFT #1')

	// let mintTx_2 = await nftContract.mintNft(
	// 	'0x60a88ec7941de1cb1f84b7ea475ae4b61f3cfe5a',
	// 	'https://jsonkeeper.com/b/XRES'
	// )
	// await mintTx_2.wait()
	// console.log('Minted NFT #2')
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
//     "image": "https://upload.wikimedia.org/wikipedia/commons/d/d1/Woo_Network_Logo.png",
//     "attributes": [
//      {
//     "trait_type": "Soulbound",
//      "value": "True"
//      },
//      {
//     "trait_type": "Woorior",
//      "value": "Newb"
//      },
//     {
//       "trait_type": "WOOX Stake Tier",
//       "value": 5
//     },
//     {
//       "trait_type": "WOOFi Stake Tier",
//       "value": 0
//     },
//     {
//       "trait_type": "WOOX Volume Tier",
//       "value": 6
//     },
//     {
//       "trait_type": "WOOFi Volume Tier",
//       "value": 1
//     },
//     {
//       "trait_type": "WOOX Diamond hands",
//       "value": 4
//     },
//     {
//     "display_type": "boost_number",
//      "trait_type": "Trading Competition Win",
//      "value": 3
//      },
//      {
//      "display_type": "date",
//      "trait_type": "birthday",
//      "value": 1651533687
//     }
//   ]
// }
// https://jsonkeeper.com/b/55WK

// {
//     "name": "WOODao Token",
//     "description": "Token to show WOO DAO voting weight",
//     "image": "https://kampungdesigner.com/wp-content/uploads/edd/2021/12/Cover-WOO-Network.jpg",
// 	"attributes": [
// 		{
// 		  "trait_type": "Base",
// 		  "value": "Starfish"
// 		},
// 		{
// 		  "trait_type": "Eyes",
// 		  "value": "Big"
// 		},
// 		{
// 		  "trait_type": "Mouth",
// 		  "value": "Surprised"
// 		},
// 		{
// 		  "trait_type": "Level",
// 		  "value": 5
// 		},
// 		{
// 		  "trait_type": "Stamina",
// 		  "value": 1.4
// 		},
// 		{
// 		  "trait_type": "Personality",
// 		  "value": "Sad"
// 		},
// 		{
// 		  "display_type": "boost_number",
// 		  "trait_type": "Aqua Power",
// 		  "value": 40
// 		},
// 		{
// 		  "display_type": "boost_percentage",
// 		  "trait_type": "Stamina Increase",
// 		  "value": 10
// 		},
// 		{
// 		  "display_type": "number",
// 		  "trait_type": "Generation",
// 		  "value": 2
// 		}
// 	  ]
// }
// https://jsonkeeper.com/b/306Z
