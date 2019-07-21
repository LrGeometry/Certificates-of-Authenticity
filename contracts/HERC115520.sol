pragma solidity ^0.5.0;
import './HERC1155.sol';
import './openzeppelin/IERC20.sol';
import './ProxyReceiver/ProxyReceiver.sol';
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
contract HERC115520 is HERC1155,IERC20,ProxyReceiver{

    constructor() public {
            nonce=nonce+1;                        
            creators[1] = msg.sender;
            balances[1][msg.sender] = _TotalSupply;
            TotalSupply[1]=_TotalSupply;
            _Name[1]=_name;
            _Symbol[1]=_symbol;
            _addTokenToOwnerEnumeration(msg.sender, 1);        
            emit TransferSingle(msg.sender, address(0x0), msg.sender, 1 ,_TotalSupply);            
            emit Transfer(address(0), msg.sender,1);
    }
    

    function balanceOf(address owner) public view returns (uint256 balance){
        
            return super.balanceOf(owner,1);

    }

    function transfer(address to, uint256 value) public returns(bool){
        super.safeTransferFrom(msg.sender, to,  1, value, "");
         // emit Transfer(msg.sender,   to,value);
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

    function transferFrom(address from, address to, uint256 value) public returns(bool){
        super.safeTransferFrom(from, to,  1, value, "");
        emit Transfer(from,   to,  value);
        return true;
    }

 
    function approve(address to,uint value) public returns(bool){
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(to != address(0), "ERC20: approve to the zero address");
       // require(allowances[msg.sender][to][1]==0);
        allowances[msg.sender][to][1] =value;
        emit Approval(msg.sender,to, 1, 0, 1);
        return true;
     }

   function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;
        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    }

    function allowance(address owner, address spender) external view returns (uint256){
        return super.allowance(owner, spender, 1);
    }


  
}