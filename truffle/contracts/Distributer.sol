pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';
import './WholeSaler.sol';

contract Distributer{
    
    MediPure mediPure;
    WholeSaler wholeSaler;
    
    
    constructor(address _mediPure,address _wholeSaler) public{
        mediPure=MediPure(_mediPure);
        wholeSaler=WholeSaler(_wholeSaler);
    }
    
    mapping(address => address[]) DrugBatchesAtDistributor;
    function drugReceivedD(
        address _bID
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles. distributer,
            "Only  Distributer can call this function"
        );
        if(Drug(_bID).getWDP()[0]!=address(0)) Drug_W_D(wholeSaler.DrugWholeSalertoDistributerTxn(_bID)).deliverPackage(_bID,msg.sender); 
        else Drug(_bID).deliverPackage(msg.sender);
        DrugBatchesAtDistributor[msg.sender].push(_bID);
    }
    
    
    
    /********************************************** Distributer Section ******************************************/
    
    
    mapping(address => address[]) public DrugDistributertoPharma;
    mapping(address=>address) public DrugDistributertoPharmaTxn;
    
    function transferDrugDistributortoPharma(
        address _bId,
        address _pharma
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.distributer &&
            msg.sender == Drug(_bId).getWDP()[1] ,
            "Only Distributer or current owner of package can call this function"
        );
        Drug_D_P dp = new Drug_D_P(
            _bId,
            msg.sender,
            _pharma
        );
        DrugDistributertoPharma[msg.sender].push(address(dp));
        DrugDistributertoPharmaTxn[_bId]=address(dp);
    }
    
    
    function getBatchesCountDistributorPharma() public view returns (uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.distributer,
            "Only Wholesaler Can call this function."
        );
        return DrugDistributertoPharma[msg.sender].length;
    }
    
    
}



