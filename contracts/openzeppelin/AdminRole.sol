pragma solidity ^0.5.0;

import "./Roles.sol";
//import "./Ownable.sol";
contract AdminRole {
    using Roles for Roles.Role;

    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);

    Roles.Role private _Admins;
    
    constructor () internal {
        _addAdmin(msg.sender);
    }

    modifier onlyAdmin() {
        require(isAdmin(msg.sender));
        _;
    }

    function isAdmin(address account) public view returns (bool) {
        return _Admins.has(account);
    }

    function addAdmin(address account) public onlyAdmin {
        _addAdmin(account);
    }

    function renounceAdmin() public {
        _removeAdmin(msg.sender);
    }

    function _addAdmin(address account) internal {
        _Admins.add(account);
        emit AdminAdded(account);
    }

    function _removeAdmin(address account) internal {
        _Admins.remove(account);
        emit AdminRemoved(account);
    }
}