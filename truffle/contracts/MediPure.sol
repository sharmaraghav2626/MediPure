pragma solidity >=0.4.0 <0.7.0;

import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';

contract MediPure{
    
    address public Owner; // Admin
    
    constructor() public{
        Owner=msg.sender;
    }
    
    /********************************************** USER CONTROLS *********************************************/
     modifier onlyOwner() {
        require(
            msg.sender==Owner,
            "Only owner can call this function."
        );
        _;
    }
    
    enum roles {
        norole,
        supplier, // Farmer
        transporter, // Delivery Service
        manufacturer, 
        wholesaler,
        distributer,
        pharma,
        revoke
    }
    
    event UserRegister(address indexed UID);
    event UserRoleRevoked(address indexed UID, uint Role);
    event UserRoleReassign(address indexed UID,uint Role);
    
    // Register new user
    function registerUser(
        address _uid,
        uint Role
        ) public
        onlyOwner
        {
        require(UsersDetails[_uid].role == roles.norole, "User Already registered");
        UsersDetails[_uid].uid = _uid;
        UsersDetails[_uid].role = roles(Role);
        users.push(_uid);
        emit UserRegister(_uid);
    }
    
    // revokeRole of User 
    function revokeRole(address _uid) public onlyOwner {
        require(UsersDetails[_uid].role != roles.norole, "User not registered");
        emit UserRoleRevoked(_uid,uint(UsersDetails[_uid].role));
        UsersDetails[_uid].role = roles(7);
    }
    
    // Reassing role
    function reassigneRole(address _uid, uint Role) public onlyOwner {
        require(UsersDetails[_uid].role != roles.norole, "User not registered");
        UsersDetails[_uid].role = roles(Role);
        emit UserRoleReassign(_uid,uint(UsersDetails[_uid].role));
    }
    
    
    // Get Current User
    function getCurrentUserInfo() public view returns(address _uid,roles _role){
        return(msg.sender,UsersDetails[msg.sender].role);
    }
 
    /********************************************** User Section **********************************************/
    
    struct UserInfo {
            address uid;
            roles role;
        }
    
    mapping(address => UserInfo) public UsersDetails;
    
    address[] public users;
    
    
    
    function getUserInfo(address _uId)   public view returns(
        roles role
        ) {
        return (
            UsersDetails[_uId].role
            );
    }
    
    function getUsersCount() public view returns(uint count){
        return users.length;
    }
    
}