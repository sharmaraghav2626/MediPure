pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';
import './Distributer.sol';

contract Pharma{
    
    MediPure mediPure;
    Distributer distributer;
    
    constructor(address _mediPure,address _distributor) public{
        mediPure=MediPure(_mediPure);
        distributer=Distributer(_distributor);
    }
    /**********************************************Pharma Section ******************************************/
    
    mapping(address => address[]) DrugBatchesAtPharma;
    
    function drugReceivedP(
        address _bID
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.pharma,
            "Only Pharma can call this function"
        );
        Drug_D_P(distributer.DrugDistributertoPharmaTxn(_bID)).deliverPackage(_bID,msg.sender);
        DrugBatchesAtPharma[msg.sender].push(_bID);
    }
    
    function getBatchesCountPharma() public view returns(uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.pharma,
            "Only Pharma or current owner of package can call this function"
        );
        return  DrugBatchesAtPharma[msg.sender].length;
    }        

}



