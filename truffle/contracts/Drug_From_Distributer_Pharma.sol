pragma solidity >=0.4.0 <0.7.0;

import './Drug.sol';

// contract between Distributer and Pharma
contract Drug_D_P {
    
    
    address Owner;

    enum packageStatus { atDistributer, pickedByDeliveryService, atPharma}

    address batchid;
    
    address distributer;
    
    address shipper;
    
    address pharma;
    
    packageStatus status;

    // Creation of Shipment from wholeSaler to Distributer
    constructor(
        address _batchid,
        address _distributer,
        address _pharma
    ) public {
        Owner = _distributer;
        batchid = _batchid;
        distributer = _distributer;
        pharma=_pharma;
        status = packageStatus(0);
    }

    // Picked package by delivery Service between wholeSaler and distributer
    function pickPackage(
        address _batchid,
        address _shipper
    ) public {
        
        status = packageStatus(1);
        shipper=_shipper;
        Drug(_batchid).send_Distributer_Pharma(
            pharma,
            distributer,
            _shipper
        );
    }
    
    // Delivered package at _distributer 
    function deliverPackage(
        address _batchID,
        address _pharma
    ) public {
        require(
            pharma == _pharma,
            "Package should be deliver to specified Pharma"
        );
        
        status = packageStatus(2);

        Drug(_batchID).deliver_Distributer_Pharma(
            _pharma,
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
