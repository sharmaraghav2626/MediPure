pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';


contract WholeSaler{
    
    MediPure mediPure;
    
    constructor(address _mediPure) public{
        mediPure=MediPure(_mediPure);
    }
    
    mapping(address => address[]) DrugBatchesAtWholesaler;
    
    function drugReceivedW(
        address _bID
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.wholesaler,
            "Only Wholesaler can call this function"
        );
        Drug(_bID).deliverPackage(msg.sender);
        DrugBatchesAtWholesaler[msg.sender].push(_bID);
    }
    
    
    
    /********************************************** Wholesaler Section ******************************************/
    
    mapping(address => address[]) public DrugWholeSalertoDistributer;
    mapping(address=>address) public DrugWholeSalertoDistributerTxn;
    
    function transferDrugWholeSalertoDistributor(
        address _bId,
        address _distributor
    ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.wholesaler &&
            msg.sender == Drug(_bId).getWDP()[0] ,
            "Only Wholesaler or current owner of package can call this function"
        );
        require(
            mediPure.getUserInfo(_distributor) == MediPure.roles.distributer,
            "Receiver should be Distributer"
        );
        Drug_W_D wd = new Drug_W_D(
            _bId,
            msg.sender,
            _distributor
        );
        DrugWholeSalertoDistributer[msg.sender].push(address(wd));
        DrugWholeSalertoDistributerTxn[_bId]=address(wd);
    }
    
    function getBatchesCountWholeSalerDistributor() public view returns (uint count){
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.wholesaler,
            "Only Wholesaler Can call this function."
        );
        return DrugWholeSalertoDistributer[msg.sender].length;
    }
    
}



