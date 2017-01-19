pragma solidity ^0.4.2;

contract TestShareManagement {
    
    struct request {
    	//address account;  //交易人
    	uint256 price;		//交易價格
    	uint256 amount;		//交易數量
    	bool is_buy;    //交易種類(buy/sell)
    	uint timestamp;	    //掛單時間
    }
    
    request[] public Requests;
    uint public length = Requests.length;
    
    /* Constructor */
    function TestStruct() {
        addRequest(0,0,false);
    }
    function updateAmount(uint256 a, uint i) returns (bool success) {
        if ( i < Requests.length)
            Requests[i].amount = a;
        else
            throw;
    }
    function getPrice(uint i) returns (uint) {
        return Requests[i].price;
    }
    function getAmount(uint i) returns(uint) {
        return Requests[i].amount;
    }
    function getLength() returns(uint) {
        return Requests.length;
    }
    function getRequests(address account) {
        request[] myRequests;
        for (uint i = 0 ; i < Requests.length ; i ++) {
            if (Requests[i].account == account){
                myRequests.push(Requests[i]);
            }
        }
    }
    function initialTrade(uint256 p, uint a, bool t) {
        if (t){  //is buy
            for (uint i = 0 ; i < Requests.length ; i ++) {
                if (){
                    
                }
            }
        }else{
            
        }
        
    }
    function addRequest(uint256 p, uint256 a, bool t){
        Requests.push(request({price:p, amount: a, is_buy: t, timestamp: now}));
        length += 1;
    }
}