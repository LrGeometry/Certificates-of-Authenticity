pragma solidity ^0.5.0;
import './HERC1155.sol';
import './openzeppelin/IERC20.sol';

/**
    ERC20 Methods that need to implemented for backward compatibility
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value); */
contract HERC115520 is HERC1155,IERC20{
    
    string _name="Hercules";
    string _symbol="HERC";
    uint _TotalSupply=234259085000000000000000000;
    uint8 _decimals=18;
  
    constructor() public {

        nonce=nonce+1;                        
        creators[1] = 0x0B4D8940930190B5c927DE740CCD682f2c658Fcd;
       
        balances[1][msg.sender] = _TotalSupply;
        TotalSupply[1]=_TotalSupply;
        _Name[1]=_name;
        _Symbol[1]=_symbol;
       
        creators[1] = 0x0B4D8940930190B5c927DE740CCD682f2c658Fcd;
        emit Transfer(address(0),0x0B4D8940930190B5c927DE740CCD682f2c658Fcd,_TotalSupply);

    }
    

    function balanceOf(address owner) public view returns (uint256 balance){
        return super.balanceOf(owner,1);

    }

    function transfer(address to, uint256 value)  whenNotPaused public returns(bool){
        super.safeTransferFrom(msg.sender, to,  1, value, "");
        emit Transfer(msg.sender,   to,value);
        return true;
    }

    function totalSupply() public view returns(uint){
        return _TotalSupply;
    }
    function name() public view returns(string memory){
        return _name;
    }

    function symbol() public view returns(string memory){
        return _symbol;
    }

    function decimals() public view returns(uint8){
        return _decimals;
    }

    function transferFrom(address from, address to, uint256 value) whenNotPaused public returns(bool){
        super.safeTransferFrom(from, to,  1, value, "");
        emit Transfer(from,   to,  value);
        return true;
    }

 
    function approve(address to,uint value) whenNotPaused public returns(bool){
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(to != address(0), "ERC20: approve to the zero address");
        
        allowances[msg.sender][to][1] =value;
        
        emit Approval(msg.sender, to, value);
        return true;
     }
   

    function allowance(address owner, address spender) external view returns (uint256){
        return super.allowance(owner, spender, 1);
    }


  
}