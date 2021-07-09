pragma solidity >=0.4.0 <0.7.0;


import './MediPure.sol';


contract Manufacturer{
    
    MediPure mediPure;
    
    constructor (address _medipure)public{
        mediPure=MediPure(_medipure);
    }
    
//  RECIEVED PACKAGES FROM RAW_MATERIALS
    mapping(address => address[]) RawPackagesAtManufacturer;
   
    function  rawPackageReceived(
        address _pId
    ) public {
        
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.manufacturer,
            "Only manufacturer can call this function"
        );

        RawMaterials(_pId).deliverPackage(msg.sender);
        RawPackagesAtManufacturer[msg.sender].push(_pId);
    }
    
    function getRawPackagesCountManufacturer() public view returns(uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.manufacturer,
            "Only manufacturer can call this function"
        );
        return RawPackagesAtManufacturer[msg.sender].length;
    }
    
    
    
    /********************************************** Manufacturer Section ******************************************/

    // GENERATE DRUG
    mapping(address=>address[]) drugs;
    
    event DrugNewBatch(
        address indexed BatchId,
        address indexed Manufacturer,
        address indexed Receiver
    );
    
    function manufactureMadicine(
        bytes32 _description,
        address[] memory _rawMaterials,
        uint _quantity,
        address _reciever,
        uint RcvrType
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.manufacturer,
            "Only manufacturer can call this function"
        );
        require(
            RcvrType != 0,
            "Receiver Type must be define"
        );
        
        if(RcvrType==1){
           require( mediPure.getUserInfo(_reciever) == MediPure.roles.wholesaler,
            "Reciver should be  wholesaler");
        }else{
            require(mediPure.getUserInfo(_reciever) == MediPure.roles.distributer,
            "Reciver should be distributer");
        }
        Drug drug=new Drug(msg.sender,_description,_rawMaterials,_quantity,_reciever,RcvrType);
        
        drugs[msg.sender].push(address(drug));
        emit DrugNewBatch(address(drug),msg.sender,_reciever);
    }
    
    function getDrugPackagesCountManufacturer() public view returns (uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.manufacturer,
            "Only Manufacturer Can call this function."
        );
        return drugs[msg.sender].length;
    }
    
    

    
}



