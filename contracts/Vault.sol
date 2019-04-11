pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
contract Vault is Ownable{

address caller;
uint createdVaults;
uint activeVaults;
uint interestRate;
uint interestInterval=86400;
uint minimumDuration;
uint maximumDuration;
uint maxDeposit;
uint minDeposit;

struct vault{
    address owner;
    uint deposit;
    uint depositTime;
    uint duration;
    uint id;
}
mapping(uint=>bool) isActive;
mapping(uint=>vault) vaults;
mapping(address=>uint[]) ownedVaults;

modifier isCaller(){
    require(msg.sender==caller);
    _;
}
constructor(address _caller,uint _interestRate) public{
    caller=_caller;
    interestRate=_interestRate;
}    

function CreateVault(address a,uint deposit,uint duration) public isCaller(){
    require(duration<=maximumDuration);
    vault memory v=vault(a,deposit,now,duration,createdVaults+1);
    vaults[createdVaults+1]=v;
    createdVaults+=1;
    activeVaults+=1;
    ownedVaults[a].push(createdVaults);
    

}

function CalculateInterest(uint id) public view returns(uint){
    vault memory v=vaults[id];
    uint amount=v.deposit;

    uint n=(now-v.depositTime)/interestInterval;

    if(n>v.duration){
        n=v.duration;
    }
    for(uint i=0;i<n;i++){
        amount=(amount*interestRate)/10000;
    }
    return amount;
}
function deActivate(uint v) public isCaller(){
    isActive[v]=false;
    activeVaults-=1;
}
function returnVaultInfo(uint v) public view returns(address,uint,uint,uint ,uint){
    return(vaults[v].owner,vaults[v].deposit,vaults[v].depositTime,vaults[v].duration,vaults[v].id);
}


}