pragma solidity >=0.4.0 <0.7.0;


import './RawMaterials.sol';
import './Drug.sol';
import './Drug_From_WholeSaler_Distributer.sol';
import './Drug_From_Distributer_Pharma.sol';
import './MediPure.sol';


contract Info{
    
    
/**********************************************Info Section ******************************************/
    
    function getProductDetails(address _pId) public view
    returns(
        address _manufacturer,
        address _bId,
        bytes32 _description,
        address[] memory _rawMaterials,
        uint _quantity
        )
    {
        return(Drug(_pId).getMadicineInfo());
    }
    function getProductCurrentOwner(address _pId) public view returns(address _Owner){
        return Drug(_pId).getPackageOwner();
    }
    function getDealers(address _pId) public view returns(address[3] memory WDP){
        return Drug(_pId).getWDP();
    }
    
    function getDrugStatus(address _batchId) public view returns(uint status){
        return Drug(_batchId).getBatchIDStatus();
    }
    
}