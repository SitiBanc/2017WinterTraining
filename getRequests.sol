    request[] public myRequests;
    function getRequests(address account) {
        delete myRequests;
        for (uint i = 0 ; i < Requests.length ; i ++) {
            if (Requests[i].account == account){
                myRequests.push(Requests[i]);
            }
        }
        
    }