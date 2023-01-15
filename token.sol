// SPDX-License-Identifier: GPL
// Author RSG
// Simple contract to create custom ERC-20 tokens
// Demonstrates usage of Interface,Inhertitance, Anonymous functions
pragma solidity ^0.4.24;

contract Token {

    function totalSupply() constant returns (uint256 supply) {}
    function balanceOf(address _owner) constant returns (uint256 balance) {}
    function transfer(address _to, uint256 _value) returns (bool success) {}
    function transferFrom(address _from, address _to, uint256 _value) returns
    (bool success) {}
    function approve(address _spender, uint256 _value) returns (bool success){}
    function allowance(address _owner, address _spender) constant returns
    (uint256 remaining) {}
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256
    _value);

}

contract RSGToken is Token {

    string public name;

    uint8 public decimals;

    string public symbol;

    uint256 public unitsOneEthCanBuy;

    uint256 public totalEthinWei;

    address public fundsWallet;

    uint256 public totalSupply;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;


    /* constructor */
    // 1 ETH = 10^18 Wei
    // 1 XYZ = 10^18
    // XYZ: totalSupply/10^decimals
    // RSGDenom : totalSupply
    constructor() public {

        balances[msg.sender] = 2000000000000000000000;

        totalSupply = 1000000000000000000000;

        name = "RSGToken";

        decimals = 18;

        symbol = "RSG";

        unitsOneEthCanBuy = 10;

        fundsWallet = msg.sender;

    }


    function transfer(address _to, uint256 _value) public returns (bool success) {

        if (balances[msg.sender]>= _value && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;

            emit Transfer(msg.sender, _to, _value);

            return true;
        }

        return false;

    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

            balances[_from] -= _value;
            balances[_to] += _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);

            return true;
        } 

        return false;

    }


     function balanceOf(address _owner) constant public returns (uint256 balance) {

         return balances[_owner];
     }

     function approve(address _spender, uint256 _value) public returns (bool success){

         allowed[msg.sender][_spender] = _value;
         emit Approval(msg.sender, _spender, _value);
         return true;

     }


     function allowance(address _owner, address _spender) constant public returns
    (uint256 remaining) {

        return allowed[_owner][_spender];
    }


    function() public payable {

        totalEthinWei = totalEthinWei + msg.value;

        uint256 amount = msg.value * unitsOneEthCanBuy;

        require(balances[fundsWallet] >= amount);

        balances[fundsWallet] = balances[fundsWallet] - amount;

        balances[msg.sender] = balances[msg.sender] + amount;

        emit Transfer(fundsWallet, msg.sender, amount);

        fundsWallet.transfer(msg.value);
    }
    

}