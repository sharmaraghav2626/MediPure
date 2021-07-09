pragma solidity >=0.4.0 <0.7.0;

// RAW MATERIALS USED

contract RawMaterials{
    
    address Owner; // Current Owner of the package 
    
    
    // Status of Package
    enum packageStatus{
        atFarm, // package at farm
        picked, // package  picked for delivery by delivery service
        delivered // package delivered to manufacturer
    }
    
    // Event
    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Manufacturer,
        uint Status
    );
    
    address productId; // id for Raw Materials(package)
    
    bytes32 description; // description of the package
    
    uint quantity; // quantity
    
    address shipper; // delivery service
    
    address manufacturer; // manufacturer
    
    address supplier; // supplier or farmer
    
    packageStatus status; // status of the package
    
    // creation of new package
    constructor (address _supplier,bytes32 _description,uint _quantity,address _manufacturer)
    public {
        productId= address(this);
        Owner=_supplier; // Supplier is current Owner
        supplier=_supplier;
        description=_description;
        quantity=_quantity;
        status=packageStatus(0);
        manufacturer=_manufacturer;
    }
    
    // get details of supplied raw materials.
    function getSuppliedRawMatrials () public view  returns(address _productId,bytes32 _description,uint _quantity,address _supplier){
        return(productId,description,quantity,supplier);
    }
    
    // get current Owner of package
    function getPackageOwner() view public returns(address _Owner){
        return Owner;
    }
    
    // get package packageStatus
    function getPackageStatus () public view returns(uint _status){
        return uint(status);
    }
    
    // package picked by Delivery service
    function pickPackage (address _shipper) public {
        require(status==packageStatus(0),'Package already shipped from the Supplier');
        shipper=_shipper;
        Owner=shipper;
        status=packageStatus(1);
        emit ShippmentUpdate(address(this),shipper,manufacturer,1);
    } 
    
    // package delivered to manufacturer
    function deliverPackage(address _manufacturer) public{
        require(status==packageStatus(1),'Package not picked up yet');
        require(manufacturer==_manufacturer,'Package Should be delivered to specified manufacturer');
        Owner=_manufacturer;
        manufacturer=_manufacturer;
        status=packageStatus(2);
        emit ShippmentUpdate(address(this),shipper,manufacturer,2);
    }
}