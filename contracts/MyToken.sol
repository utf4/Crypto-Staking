// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./Stakeable.sol";

contract MyToken is Stakeable{
    
     
    string public name;
    string public symbol;
    uint256 public decimal;
    uint256 public totalSupply;
    address public contract_owner;
    
    mapping  (address => uint256) public balances;
    mapping (address => mapping(address => uint256)) public allowances;
    
    event Transfer(address sender, address receiver, uint256 amount ) ;
    
    event Allowance(address owner, address spender, uint256 amount );
    
    modifier OnlyOwner {
        require (msg.sender == contract_owner);
        _;
    }
    
    constructor(string memory _name, string memory _symbol, uint256 _decimal, uint256 _totalSupply){
        name = _name;
        symbol = _symbol; 
        decimal = _decimal;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
        contract_owner = msg.sender;
        
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(uint256 amount, address recepient) external {
        require (balances[msg.sender] >= amount);
        require (recepient != address(0));
        _trasnfer(msg.sender, recepient, amount);
    }
    
    function _trasnfer(address sender, address recepient, uint256 amount) internal{
        
        balances[sender] = balances[sender] - amount;
        balances[recepient] = balances [recepient] +amount;
        
        emit Transfer(msg.sender, recepient, amount);
    }
    
    function approve(address recepient, uint256 amount) external {
        require (balances[msg.sender] >= amount);
        allowances [msg.sender][recepient] = amount;
        emit Allowance(msg.sender,recepient, amount);
    } 
    
    function transferFrom(address owner,address recepient, uint256 amount) external{
        require(allowances[owner][msg.sender] >= amount);
        require(balances[owner] >= amount);
        require(recepient != (address(0)));
        
        _trasnfer (owner, recepient, amount);
        
        allowances[owner][msg.sender]  =  allowances[owner][msg.sender] - amount; 
        
    }
    
    function _mint(address recepient, uint256 amount) internal {
        require(recepient != address(0));
        balances[recepient]  = balances [recepient] + amount;
        totalSupply = totalSupply + amount;
        
        emit Transfer(address(0), recepient, amount);
    } 
    
    function mint(address recepient, uint256 amount) external OnlyOwner returns (bool) {
        _mint(recepient, amount);
        return true; 
    }
    
    function burn(address sender, uint256 amount ) external OnlyOwner returns (bool) {
        _burn (sender, amount); 
        return true; 
    }
    
    function _burn(address sender, uint256 amount) internal{
        require (sender != address(0));
        require (balances[sender] >= amount);
        balances [sender] = balances[sender] - amount;
        totalSupply = totalSupply - amount; 
        emit Transfer(sender, address(0), amount);
        
    }
    
    function stake_amount(uint256 amount) external {
        
        _stake(msg.sender,amount);
        _burn(msg.sender, amount);
        
    } 
    
    function withdrawStake(uint256 amount, uint256 index) external{
        
        uint256 reward = _withdrawStake (msg.sender, amount, index);
        _mint(msg.sender,amount+reward);
        
    }
    
    // function stakedsummary() external returns (struct UserSummary){
    //     return _calculateSummary(msg.sender);
    // }
     
    
    
    
}