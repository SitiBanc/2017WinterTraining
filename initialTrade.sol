    function initialTrade(uint256 p, uint a, bool t) {
        uint i = 0;
    	if (t){  //is buy
    		for (i = 0 ; i < Requests.length ; i ++) {
    		    //check price
    		    //想要的價格>=提供價格 
    			if (p >= Requests[i].price) {
    			    //check amount
    			    if(a>=Requests[i].amount){
    			       //想要的數量>=提供的數量 開始交易
    			       //(賣單交易成立)消除賣單
    			       a-=Requests[i].amount;
    			       removeRequests(i);
    			    }else{
    			        //提供的數量>想要的數量
    			        Requests[i].amount-=a;
    			        a=0;
    			    }
    			}
    		}
    		//check price
    		//想要的價格<提供價格 
    		if(a!=0)
			addRequest(0x1Bf1bfaBb994133e0964Ef1a99BDFC9bc0fd5763,p, a, t);	
		
    	}
    }