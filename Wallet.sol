pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
   
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
    }

    //Отправить без оплаты комиссии за свой счет (flag = 0)
    function sendValueFree(address dest, uint128 value) public checkOwnerAndAccept{
        bool bounce = true;
        uint16 flag = 0;
        dest.transfer(value, bounce, flag);
    }
    
    //Отправить с оплатой комиссии за свой счет (flag = + 1)
    function sendValue(address dest, uint128 value) public checkOwnerAndAccept {
        bool bounce = true;
        uint16 flag = 1;
        dest.transfer(value, bounce, flag);
    }
    
    //Отправить все деньги и уничтожить кошелек (flag = 160)
    function sendAndKill(address dest) public checkOwnerAndAccept {
        bool bounce = true;
        uint16 flag = 160;
        uint128 value = 1;
        dest.transfer(value, bounce, flag);
    }
 
}