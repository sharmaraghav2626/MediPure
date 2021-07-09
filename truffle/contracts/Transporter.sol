pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';
import './Distributer.sol';
import './WholeSaler.sol';

contract Transporter{
    
    MediPure mediPure;
    WholeSaler wholeSaler;
    Distributer distributer;
    
    constructor(address _medipure,address _wholeSaler,address _distributer) public{
        mediPure=MediPure(_medipure);
        wholeSaler=WholeSaler(_wholeSaler);
        distributer=Distributer(_distributer);
    }
    
/********************************************** Transporter Section ******************************************/

    function loadConsingment(
        address pid, //Package or Batch ID
        uint transportertype
        ) public {
        require(
            mediPure.getUserInfo(msg.sender) == MediPure.roles.transporter,
            "Only Transporter can call this function"
        );
        require(
            transportertype > 0,
            "Transporter Type must be define"
        );

        if(transportertype == 1) {  // Supplier to Manufacturer
            RawMaterials(pid).pickPackage(msg.sender);
        } else if(transportertype == 2) {   // Manufacturer to Wholesaler OR Manufacturer to Distributer
            Drug(pid).pickPackage(msg.sender);
        } else if(transportertype == 3) {   // Wholesaler to Distributer
            Drug_W_D(wholeSaler.DrugWholeSalertoDistributerTxn(pid)).pickPackage(pid,msg.sender);
        } else if(transportertype == 4) {   // Distrubuter to Pharma
            Drug_D_P(distributer.DrugDistributertoPharmaTxn(pid)).pickPackage(pid,msg.sender);
        }
    }

}