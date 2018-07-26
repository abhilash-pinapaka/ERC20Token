pragma solidity ^0.4.20;

contract TokenLaunch{
    
    address public _owner = msg.sender;
    string tokenname="sarath";
    string tokensymbol="ast";
    uint tokenprice=1;
    mapping (address => uint) balances;
    uint  tokendecimals=2;
    uint  tokensupply=1000;
    uint totalunits = tokensupply * 10**tokendecimals;
    mapping(address =>mapping (address => uint)) allowances;
    uint public tokensbought;
    
    event Transfer(address indexed _from, address indexed _to, uint value);
    
    
    function() public payable{
        require(tokensbought < totalunits);
        if (tokensbought <= totalunits/2){
            uint tokenvalue = tokenprice * 1000000000000000000 wei;
            tokenvalue = tokenvalue/2;
            
        }else{
            tokenvalue = tokenprice * 1000000000000000000 wei;
            
        }
        uint tokens = (msg.value * 10**tokendecimals) / tokenvalue;
        uint cost = tokenvalue * tokens/10**tokendecimals;
        uint extrawei = msg.value - cost;
        if (balances[msg.sender] > 0){
            balances[msg.sender] += tokens;
            tokensbought += tokens;
         }else{
            balances[msg.sender] = tokens;
            tokensbought += tokens;
         }
        if (extrawei > 0){
            msg.sender.transfer(extrawei);
         }
    }
    
    function name() public view returns(string){
        return tokenname;
    }

    modifier isOwner() {
        require(_owner == msg.sender,"Not Authorized");
        _;
    }

    function symbol() public view returns (string){
        return tokensymbol;
    }

    function totalsupply() public view returns(uint){
        return tokensupply;
    }

    function balanceOf(address _addr) public view returns(uint){
        return balances[_addr];
    }

    function decimals() public view returns(uint){
        return tokendecimals;
    }
    
    function transfer(address _to, uint value) public returns (bool) { 
        require(_to != address(0));
        require(balances[msg.sender]>0);
        if(balances[_to] > 0){
            balances[msg.sender] -= value;
            balances[_to] += value;
        }else{
            balances[msg.sender] -= value;
            balances[_to] = value;
        }
        emit Transfer(msg.sender,_to, value);
        return true;
    }
    function approve (address _spender, uint value) public returns (bool){
        require(balances[msg.sender] > value);
        allowances[msg.sender][_spender] = value;
        return true;
    }

    function transferFrom(address _from, address _to, uint value) public   {
        require(allowances[_from][msg.sender]>value);
        require(balances[_from]>0 && balances[_from]>value);
        balances[_from] -= value;
        balances[_to] += value;
        
    }
    
    //event Approval(address indexed _owner, address indexed _spender, uint value);
    function allowance(address _own, address _spender) public view returns(uint) {
        return allowances[_own][_spender];
    }
    
    function withdraw() isOwner public {
        _owner.transfer(address(this).balance);        
    }
}