function initialTrade(uint256 p, uint a, bool t) {
	if (t){  //is buy
		for (uint i = 0 ; i < sellRequests.length ; i ++) {
			if (p >= sellRequests[i].price){
				//check amount
			}
		}
	}else{  //is sell
		for (i = 0 ; i < buyRequests.length ; i ++) {
			if (p >= buyRequests[i].price){
				//check amount
			}
		}
	}
}