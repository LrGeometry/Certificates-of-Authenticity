pragma solidity ^0.5.0;
import './openzeppelin/AdminRole.sol';
import './ERC/SafeMath.sol';
contract Futurist is AdminRole{
    using SafeMath for *;
    mapping(uint=>uint) public FuturistPoints;  
    
    function addPoints(uint p,uint token) onlyAdmin() public {
        FuturistPoints[token]=FuturistPoints[token].add(p);
    }

}