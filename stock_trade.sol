pragma solidity ^0.4.2;

contract TestShareManagement {
    
    struct request {
    	address account;    //交易人
    	uint256 price;		//交易價格
    	uint256 amount;		//交易數量
    	bool is_buy;        //交易種類(buy/sell)
    	uint timestamp;	    //掛單時間
    }
    
    request[] public sellRequests;  //賣單
    request[] public buyRequests;   //買單
    request[] public myRequests;    //我的掛單(user搜尋自己的掛單)
    uint public length = sellRequests.length + buyRequests.length;  //not important
    
    /* Constructor */
    function TestShareManagement() {
        
    }
    function updateAmount(bool t, uint256 a, uint i) {
        if (t) {    //更新買單數量
            if ( i < buyRequests.length)
                buyRequests[i].amount = a;
            else
                throw;
        }else {     //更新賣單數量
            if ( i < sellRequests.length)
                sellRequests[i].amount = a;
            else
                throw;
        }
    }
    /*function getPrice(uint i) returns (uint) {
        return Requests[i].price;
    }
    function getAmount(uint i) returns (uint) {
        return Requests[i].amount;
    }
    function getLength() returns (uint) {
        return Requests.length;
    }*/
    function findMyRequests(address account) {
        delete myRequests;
        for (uint i = 0 ; i < sellRequests.length ; i ++) {
            if (sellRequests[i].account == account)
                myRequests.push(sellRequests[i]);
        }
        for (i = 0 ; i < buyRequests.length ; i ++) {
            if (buyRequests[i].account == account)
                myRequests.push(buyRequests[i]);
        }
    }
    function initialTrade(uint256 p, uint a, bool t) {
        if (t){  //is buyer
            for (uint i = 0 ; i < sellRequests.length ; i ++) {
                if (p >= sellRequests[i].price){
                    //check amount
                }
            }
        }else{  //is seller
            for (i = 0 ; i < buyRequests.length ; i ++) {
                if (p >= buyRequests[i].price){
                    //check amount
                }
            }
        }
        
    }
    function addRequest(uint256 p, uint256 a, bool t) {
        if (t) {    //is buyer
            buyRequests.push(request({account: msg.sender, price:p, amount: a, is_buy: t, timestamp: now}));
        }else {     //is seller
            sellRequests.push(request({account: msg.sender, price:p, amount: a, is_buy: t, timestamp: now}));
            /*//允許本contract未來交易搓合時能執行transferFrom()
            approve(this, a);
            */
        }
        
        length += 1;
    }
    function removeRequest(bool t, uint TargetIndex) {
        if (t) {    //買單移除
            for (uint i = TargetIndex ; i < buyRequests.length-1 ; i++) {
                uint a = buyRequests[TargetIndex].amount;
                buyRequests[TargetIndex] = buyRequests[i+1];    //TargetIndex之後(含)往前shift
                delete buyRequests[buyRequests.length-1];       //刪除最後一筆
                buyRequests.length--;                           //總長度-1
            }
        }else {     //賣單移除
            for (i = TargetIndex ; i < sellRequests.length-1 ; i++) {
                sellRequests[TargetIndex] = sellRequests[i+1];      //TargetIndex之後(含)往前shift
                delete sellRequests[sellRequests.length-1];         //刪除最後一筆
                sellRequests.length--;                              //總長度-1
                /*//disapprove
                disapprove(this, a);
                */
            }
        }
    }
}