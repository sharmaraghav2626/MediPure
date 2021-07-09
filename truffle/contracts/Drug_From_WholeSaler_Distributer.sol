pragma solidity >=0.4.0 <0.7.0;

import './Drug.sol';

// contract between WholeSaler and Distributer 
contract Drug_W_D {
    
    
    address Owner;

    enum packageStatus { atWholeSaler, pickedByDeliveryService, atDistributer}

    address batchid;
    
    address distributer;
    
    address shipper;
    
    address wholeSaler;
    
    packageStatus status;

    // Creation of Shipment from wholeSaler to Distributer
    constructor(
        address _batchid,
        address _wholeSaler,
        address _distributer
    ) public {
        Owner = _wholeSaler;
        batchid = _batchid;
        wholeSaler = _wholeSaler;
        distributer = _distributer;
        status = packageStatus(0);
    }

    // Picked package by delivery Service between wholeSaler and distributer
    function pickPackage(
        address _batchid,
        address _shipper
    ) public {
        
        status = packageStatus(1);
        shipper=_shipper;
        Drug(_batchid).send_WholeSaler_Distributer(
            distributer,
            wholeSaler,
            _shipper
        );
    }
    
    // Delivered package at _distributer 
    function deliverPackage(
        address _batchID,
        address _distributer
    ) public {
        require(
            distributer == _distributer,
            "Package should be deliver to specified Distributor"
        );
        
        status = packageStatus(2);

        Drug(_batchID).deliver_WholeSaler_Distributer(
            _distributer,
            shipper
        );
    }

    // Get batch status
    function getBatchIDStatus() public view returns(
        uint
    ) {
        return uint(status);
    }

}
