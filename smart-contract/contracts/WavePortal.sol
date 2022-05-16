// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed; // Gerar número randômico

    event NewWave(address indexed from, uint256 timestamp, string message);

/*
Um struct é basicamente um tipo de dados customizado onde nós podemos customizar o que queremos armazenar dentro dele.
*/
    struct Wave {
        address waver; // Endereço do usuário que deu tchauzinho
        string message; // Mensagem que o usuário enviou
        uint256 timestamp; // Data/hora de quando o usuário deu tchauzinho
    }

/*
Declara a variável waves que permite armazenar um array de structs.
Isto que me permite armazenar todos os tchauzinhos que qualquer um tenha me enviado.
*/
    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("EU SOU UM CONTRATO INTELIGENTE. CONTRATO NO AR!");
        /* Define a seed inicial */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    /*
    Mudei um pouco a função de tchauzinho e agora requer uma string chamada _message. Esta é a mensagem que o nosso usuário enviou pelo frontend.
    */
    function wave(string memory _message) public {

        /* Precisamos garantir que o valor corrente de timestamp é ao menos 
        15 minutos maior que o último timestamp armazenado */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Espere 15m"
        );

        /* Atualiza o timestamp atual do usuário */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s deu tchauzinho com a mensagem %s", msg.sender, _message);

        /*
        Aqui é onde eu efetivamente armazeno o tchauzinho no array.
        */
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /* Gera uma nova semente para o próximo usuário que acenar */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s venceu!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;

            require(
                prizeAmount <= address(this).balance,
                "Tentando sacar mais dinheiro que o contrato possui."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar dinheiro do contrato.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    /*
    Adicionei uma função getAllWaves que retornará os tchauzinhos.
    Isso permitirá recuperar os tchauzinhos a partir do site.
    */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Temos %d tchauzinhos no total!", totalWaves);
        return totalWaves;
    }
}