pragma solidity >=0.4.0 <0.7.0;


// Drug (Manufactured by manufacturer with raw materials)

contract Drug{
    
    address Owner; // Current Owner of the package 
    
    
    // Status of Package
    enum drugStatus {
        atManufacturer, // Package at manufacturer
        picked4WholeSaler, // Package picked by delivery service for Wholesaler
        picked4Distributor, // Package picked by delivery service for Distributor
        deliveredatWholeSaler, // Package delivered at Wholesaler
        deliveredatDistributor, // Package delivered at Distributor
        picked4Pharma,
        deliveredatPharma
    }
    
    
    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint Status
    );
    
    
    address batchid;
   
    bytes32 description;
    
    address[] rawMaterials;
   
    uint quantity;
   
    address shipper;
   
    address manufacturer;
   
    address wholesaler;
   
    address distributer;
   
    address pharma;
   
    drugStatus status;
    
    // Create Drug
     constructor(
        address _manufacturer,
        bytes32 _description,
        address[] memory _rawMaterials,
        uint _quantity,
        address _receiver,
        uint RcvrType
    ) public {
        Owner = _manufacturer;
        manufacturer = _manufacturer;
        batchid = address(this);
        description=_description;
        rawMaterials = _rawMaterials;
        quantity = _quantity;
        if(RcvrType == 1) {
            wholesaler = _receiver;
        } else if( RcvrType == 2){
            distributer = _receiver;
        }
     } 
    
    
    /// Get Drug Batch Deails
    function getMadicineInfo () public view returns(
        address _manufacturer,
        address _batchid,
        bytes32 _description,
        address[] memory _rawMaterials ,
        uint _quantity
    ) {
        return(
            manufacturer,
            batchid,
            description,
            rawMaterials,
            quantity
        );
    } 
    
    // Get Batch status
    function getBatchIDStatus() public view returns(
        uint
    ) {
        return uint(status);
    }
    
    // get current Owner of package
    function getPackageOwner() public view returns(address _Owner){
        return Owner;
    }
    
    // get wholesaler,distributer,pharma
    function getWDP() public view returns(address[3] memory WDP) {
        return (
            [wholesaler,distributer,pharma]
        );
    }
    
    // pick package by delivery service
    function pickPackage(address _shipper)  
    public {
        require(
            status == drugStatus(0),
            "Package must be at Supplier."
        );
        
        shipper=_shipper;
        Owner=_shipper;
            
        if(wholesaler!=address(0)){  // check if wholesaler is there other wise shipped to distributer
            status = drugStatus(1);
            emit ShippmentUpdate(address(this),shipper,wholesaler,1);
        }else{
            status = drugStatus(2);
            emit ShippmentUpdate(address(this),shipper,distributer,1);
        }
    }
    
    // Recieve Package by wholesaler or distributer
    function deliverPackage(address _receiver) public
    {

        require(
            _receiver == wholesaler || _receiver == distributer,
            "Package should be deliver to specified Distributor or Wholesaler"
        );

        require(
            uint(status) >= 1,
            "Product not picked up yet"
        );
        
        Owner=_receiver;
        
        if(_receiver == wholesaler && status == drugStatus(1)){
            status = drugStatus(3);
            emit ShippmentUpdate(address(this),shipper,wholesaler,3);
            
        } else if(_receiver == distributer && status == drugStatus(2)){
            status = drugStatus(4);
            emit ShippmentUpdate(address(this),shipper,distributer,4);
        }
    }
    
    
    // pick Package from Wholesaler 
    function send_WholeSaler_Distributer(
        address _distributer,
        address _wholesaler,
        address _shipper
    ) public {
        require(
            wholesaler == _wholesaler,
            "WholeSaler is not associated with this Package"
        );
        require(status==drugStatus(3),'Package not at WholeSaler');
        
        Owner=_shipper;
        distributer = _distributer;
        status = drugStatus(2);
        emit ShippmentUpdate(address(this),_shipper,_distributer,2);
    }
    
    
    // deliver package at Distributor
    function deliver_WholeSaler_Distributer(
        address _distributer,
        address _shipper
    ) public {
        require(
            distributer == _distributer,
            "Distributor is not associated with this Package"
        );
        Owner=_distributer;
        status = drugStatus(4);
        emit ShippmentUpdate(address(this),_shipper,_distributer,4);
    }
    
    
    
    // pick Package from Distributorr 
    function send_Distributer_Pharma(
        address _pharma,
        address _distributer,
        address _shipper
    ) public {
        require(
            distributer == _distributer,
            "Distributor is not associated with this Package"
        );
        require(status==drugStatus(4),'Package not at Distributer');
        Owner=_shipper;
        pharma = _pharma;
        status = drugStatus(5);
        emit ShippmentUpdate(address(this),_shipper,_pharma,5);
    }
    
    // deliver package at Pharma
    function deliver_Distributer_Pharma(
        address _pharma,
        address _shipper
    ) public {
        require(
            pharma == _pharma,
            "Pharma is not associated with this Package"
        );
        Owner=_pharma;
        status = drugStatus(6);
        emit ShippmentUpdate(address(this),_shipper,_pharma,6);
    }
}