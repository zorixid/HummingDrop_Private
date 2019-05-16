pragma solidity ^0.4.23;

// ----------------------------------------------------------------------------
// HummingDrop TRC20 token airdrop smart contract, airdroper pays fees
// Only works with TRC20 tokens, TRX Token or TRC10 - Not supported
// 2019 (c) by Justinas K
// ----------------------------------------------------------------------------

/**
* TRC20 token interface
*/ 
contract TRC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

/**
* HummingDrop Airdrop contract and constructor
* default token address added in 0xCheckSum format
* ! check lower, upper case
*/    
contract HummingDrop{
    string myMessage = "Completed";
    address public manager;
    address public admin1;
    address public admin2;
    address public trc20tokenAddress = 0x047161A0E786990C51587ab83ff4945F6E8D0a92 ;
    address[] public myArray;
    uint public balanceNow = 0;

    constructor () public {
    manager = msg.sender;
    admin1 = msg.sender;
    admin2 = msg.sender;
    }
    
/**
* Function Modifier: only manager, admin1 or admin2 able to run this type of functions
* returns Error message
*/    
    modifier restricted() {
        require (msg.sender == manager || msg.sender == admin1 || msg.sender == admin2, "ERROR - You dont have Manager or Administrator rights");
        _;
    }
    
/**
* returns Returns number of users, array.length
*/     
    function numberOfUsers() public view restricted returns (uint) {
        return myArray.length;
    }
    
/**
* returns Returns complete array of users
*/     
    function completeListOfUsers() public view restricted returns (address[]) {
        return myArray;
    }
    
/**
* Function to set new admin1, only manager is able to add admins
* parameter address
* returns message: "Completed"
*/     
    function setNewAdmin1(address _newAdmin1 ) public returns (string) {
        require (msg.sender == manager, "ERROR - Only Manager can change Admin roles");
        admin1 = _newAdmin1;
        return myMessage;
    }
    
/**
* Function to set new admin2, only manager is able to add admins
* parameter address
* returns message: "Completed"
*/      
    function setNewAdmin2(address _newAdmin2 ) public returns (string) {
        require (msg.sender == manager, "ERROR - Only Manager can change Admin roles");
        admin2 = _newAdmin2;
        return myMessage;
    }
    
/**
* Function to set new token, only manager or admin is able to change token address
* parameter token contract address
* returns message: "Completed"
*/      
    function setNewToken(address _tokenContract ) public returns (string) {
        require (msg.sender == manager, "ERROR - Only Manager can change Admin roles");
        trc20tokenAddress = _tokenContract;
        return myMessage;
    }
    
/**
* Function to upload list of addresses, takes argument 
* parameter array of addresses ["TEST6KPenCBGCxTWC7fSoAb1YrhH2wom21", "TEST6............2"]
* returns message: "Completed"
*/      
    function enterListOfUsers(address[] myList ) public restricted returns (string) {
        myArray = myList;
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        balanceNow = (_TRC20Instance.balanceOf(address(this))) /myArray.length ;
        return myMessage;
    }
    
/**
* Function to check someone else balance, to check Token Balance
* parameter wallet addresses
*/    
    function balanceOfsomeoneElse(address tokenOwner) public view restricted returns (uint balance){
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        return _TRC20Instance.balanceOf(address(tokenOwner));
    }
    
/**
* Function to check contract Token Balance
* returns contract balance without decimals  
*/    
    function showTRC20TokenBalanceDivided() public view restricted returns(uint){
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        return _TRC20Instance.balanceOf(address(this)) / 1000000000000000000;
    }
    
/**
* Function to check contract Token Balance
* returns contract balance full 18dec  
*/       
    function showTRC20TokenBalance() public view restricted returns(uint){
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        return _TRC20Instance.balanceOf(address(this)) ;
    }
    
/**
* Function to check redistribution ammount for each user
* returns ammount of tokens  
*/       
    function howMuchEachGetting() public view restricted returns(uint){
        return balanceNow;
    }
    
/**
* Function to send 1 test token from contract to msg.sender
* returns message: "Completed"
*/       
    function transferToken1toMe() public restricted returns (string) {
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        _TRC20Instance.transfer(msg.sender, 1000000000000000000);
        return myMessage;
    }
    
/**
* Function to send all tokens from contract to msg.sender
* returns message: "Completed"
*/     
    function transferTokensALLtoMe() public restricted returns (string) {
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        _TRC20Instance.transfer(msg.sender, _TRC20Instance.balanceOf(address(this)) );
         return myMessage;
    }
    
/**
* Function to reset everything, resets array,length, balanceNow
* returns message: "Completed"
*/     
    function resetEverything() public restricted returns (string) {
        balanceNow = 0;
        myArray = new address[](0);
        return myMessage;
    }
    
/**
* Function to start Airdrop to imported array of addresses
* resets everything back to 0 after finished
* returns message: "Completed"
*/     
    function startAirdrop() public restricted returns (string) {
        TRC20Interface _TRC20Instance = TRC20Interface(trc20tokenAddress);
        for (uint i = 0; i < myArray.length; i++) {
        _TRC20Instance.transfer(myArray[uint(i)], balanceNow )  ;
    }
        resetEverything();
        return myMessage;
    }
}
