const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Endereço do contrato:", waveContract.address);

  /* Consulta saldo do contrato */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Saldo do contrato: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const waveTxn = await waveContract.wave("Mensagem 1");
  await waveTxn.wait();
  const waveTxn2 = await waveContract.wave("Mensagem 2");
  await waveTxn2.wait();

  /* Recupera o saldo do contrato para verificar o que aconteceu */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Saldo do  contrato: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();
  console.log(waveCount.toNumber());

  const [_, randomPerson] = await hre.ethers.getSigners();
  waveTxn = await waveContract.connect(randomPerson).wave("Outra mensagem!");
  await waveTxn.wait(); // aguarda a transação ser minerada
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();