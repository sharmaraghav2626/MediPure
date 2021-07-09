pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';

contract Supplier{
    
    MediPure mediPure;
    
    constructor(address _medipure) public{
        mediPure=MediPure(_medipure);
    }
    
    // Supplier
    function getSuppliedRawMatrials (address _pId) public view  returns(address _productId,bytes32 _description,uint _quantity,address _supplier){
        return RawMaterials(_pId).getSuppliedRawMatrials();
    }
    
    function getRawMaterialPackageOwner(address _pId) view public returns(address _Owner){
        return RawMaterials(_pId).getPackageOwner();
    }
    
    function getRawMaterialPackageStatus(address _pId) public view returns(uint _status){
        return RawMaterials(_pId).getPackageStatus();
    }
    
    
   //********************************************* Supplier/Farmer Section ******************************************/
    
    mapping(address => address[]) supplier;
    
    event RawSupplyInit(
        address indexed ProductID,
        address indexed Supplier,
        address indexed Receiver
    );
    
    function createRawPackage(
        bytes32 _description,
        uint _quantity,
        address _reciever
        ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.supplier,
            "Only Supplier Can call this function "
        );
        require(
            mediPure.getUserInfo(_reciever) == MediPure.roles.manufacturer,
            "Receiver should be Manufacturer "
        );
        RawMaterials rawData = new RawMaterials(
            msg.sender,
            _description,
            _quantity,
            _reciever
            );
        supplier[msg.sender].push(address(rawData));
        emit RawSupplyInit(address(rawData),msg.sender,_reciever);
    }
    
    function getRawMaterialPackagesCountS() public view returns (uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.supplier,
            "Only Supplier Can call this function "
        );
        return supplier[msg.sender].length;
    }
}