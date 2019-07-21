pragma solidity ^0.5.0;
import './openzeppelin/AdminRole.sol';

contract Futurist is AdminRole{

    mapping(uint=>uint) public FuturistPoints;  
    
    function addPoints(uint p,uint token) public onlyAdmin(){
        FuturistPoints[token]+=p;
    }

}