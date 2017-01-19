pragma solidity ^0.4.2;
/*Contracts in Solidity are similar to classes in object-oriented languages.*/
contract owned {	//名叫owned的contract
    address public owner;	//owner:token發行者

    function owned() {	//設定ownership為msg.sender(即發送contract者)
        owner = msg.sender;
    }

    modifier onlyOwner {	//限制該msg.sender必須為owner
        if (msg.sender != owner) throw;
        _;	//看瞴
    }

    function transferOwnership(address newOwner) onlyOwner {	//token發行人變動(必須由當前owner執行)
        owner = newOwner;
    }
}

contract tokenRecipient {	//名叫tokenRecipient的contract(token收據)
	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
	}						//token sender地址,送的token量,看瞴,額外資訊

contract token {	//名叫token的contract(也是我們上課時用的版本)
    /* Public variables of the token */
    string public standard = 'Token 0.1';	//token版本?
    string public name;		//token名
    string public symbol;	//token符號
    uint8 public decimals;	//token位數
    uint256 public totalSupply;	//token總發行量

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;	//叫balanceOf的mapping資料結構(儲存地址->餘額)
    mapping (address => mapping (address => uint256)) public allowance;	//叫allowance的mapping資料結構(意義不明)->第一個address(錢包)擁有者授權->第二個address(合約)使用->某數量的token

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);	//名叫Transfer的event(event會broadcast出去)
					//送出token的address, 收到token的address, transfer的token數量
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function token(		//token建構元
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
        ) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows 避免溢位
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value)      //msg.sender授權_spender(另一個address)使用其餘額中_value數量的token吧~
        returns (bool success) {
        allowance[msg.sender][_spender] += _value;
        tokenRecipient spender = tokenRecipient(_spender);
        return true;
    }
    
    function disapprove(address _spender, uint _value) returns (bool success) {
        allowance[msg.sender][_spender] -= _value;
        tokenRecipient spender = tokenRecipient(_spender);
        return true;
    }

    /* Approve and then comunicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
	//msg.sender授權_spender(另一個address)使用其餘額中_value數量的token並利用tokenRecipient傳遞額外訊息(_extraData)
        returns (bool success) {    //看瞴
        tokenRecipient spender = tokenRecipient(_spender);	//= 右邊看瞴
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {	//被approve的address使用此function花用其allowance
        if (balanceOf[_from] < _value) throw;					// Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;	// Check for overflows 避免溢位
        if (_value > allowance[_from][msg.sender]) throw;		// Check allowance 檢查索取的token數量是否超出被授權的數量
        balanceOf[_from] -= _value;								// Subtract from the sender
        balanceOf[_to] += _value;								// Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}

contract MyAdvancedToken is owned, token {	//進階版Token(is可能是繼承的意思，繼承owned, token)

    uint256 public sellPrice;
    uint256 public buyPrice;
    uint256 public totalSupply;

    mapping (address => bool) public frozenAccount;	//使用mapping儲存某address是否為frozenAccount

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyAdvancedToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol,
        address centralMinter
    ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {
        if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
        balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if (frozenAccount[msg.sender]) throw;                // Check if frozen
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }


    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (frozenAccount[_from]) throw;                        // Check if frozen            
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {	//鑄造mintedAmount數量的新token，並傳送至target地址
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, this, mintedAmount);
        Transfer(this, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner {	//凍結target地址(freeze = true)或解凍target地址(freeze = false)，限制只有token owner(發行者)執行
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    function buy() payable {
        uint amount = msg.value / buyPrice;                // calculates the amount
        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
        balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
        balanceOf[this] -= amount;                         // subtracts amount from seller's balance
        Transfer(this, msg.sender, amount);                // execute an event reflecting the change
    }

    function sell(uint256 amount) {
        if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
        balanceOf[this] += amount;                         // adds the amount to owner's balance
        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
        if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
            throw;                                         // to do this last to avoid recursion attacks
        } else {
            Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
        }               
    }
}