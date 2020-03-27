pragma solidity >=0.4.21 <0.7.0;

// AAVE required interfaces
interface LendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
}

interface LendingPool {
    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
    function getReserveConfigurationData(address _reserve) external;
    function getUserReserveData(address _reserve, address _user) external;
}

interface AToken {
    function redeem(uint256 _amount) external;
}

contract HybridBank {
    uint8 private clientCount;
    struct Account {
        uint256 balance;
        uint256 investmentThreshold;
        uint256 minBalance;
        uint256 invested;
    }
    mapping(address => Account) private accounts;

    address public owner;
    
    // AAVE variables
    LendingPool lendingPool;
    AToken aToken;
    uint16 private referral;
    address underlying_asset;


    // Log the event about a deposit being made by an address and its amount
    event LogDepositMade(address indexed accountAddress, uint256 amount);
    event LogLendingPool(LendingPoolAddressesProvider provider, LendingPool lendingPool);
    
    // Constructor is "payable" so it can receive the initial funding of 30,
    // required to reward the first 3 clients
    // Ropsten details
    // LendingPool AddressesProvider 0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728
    // aToken instance 0x2433A1b6FcF156956599280C3Eb1863247CFE675
    // aDai asset address 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108
    // aETH asset address 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    // Dai smart contract 0x580D4Fdc4BF8f9b5ae2fb9225D584fED4AD5375c

    constructor(LendingPoolAddressesProvider _lendingPoolAddressesProvider,
                 address _aTokenAddress,
                 address _underlying_asset,
                 uint16 _referral) 
                 public payable {
         /* Set the owner to the creator of this contract */
         owner = msg.sender;

         /// Initialise AAVE
         /// Retrieve LendingPool address

        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(_lendingPoolAddressesProvider);
        lendingPool = LendingPool(provider.getLendingPool());
        aToken = AToken(_aTokenAddress);
        underlying_asset = _underlying_asset;
        referral = _referral;

        emit LogLendingPool(provider, lendingPool);

      }
    
    /// @notice Deposit ether into bank, requires method is "payable"
    /// @return The balance of the user after the deposit is made
    function deposit(uint256 _amount) public payable returns (uint256, uint256) {
        uint256 amount_to_invest;
        // Add deposit amount to balance
        accounts[msg.sender].balance += _amount;

        // If current balance is higher than investmentThresdhold
        if ((accounts[msg.sender].investmentThreshold > 0) && (accounts[msg.sender].balance > accounts[msg.sender].investmentThreshold))  {
            amount_to_invest = accounts[msg.sender].balance - accounts[msg.sender].investmentThreshold;
            // Desposit the Money to a AAVE lendingPool 
            // lendingPool.deposit(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, amount_to_invest , referral);
            accounts[msg.sender].invested += amount_to_invest;
            accounts[msg.sender].balance -= amount_to_invest;
        }

        emit LogDepositMade(msg.sender, msg.value);
        return (accounts[msg.sender].balance, accounts[msg.sender].invested);
    }

    /// @notice Withdraw ether from bank
    /// @return remainingBal The balance remaining for the user
    function withdraw(uint256 withdrawAmount)
        public
        returns (uint256 remainingBal)
    {
        // Check enough balance available, otherwise just return balance
        if (withdrawAmount <= accounts[msg.sender].balance) {
            accounts[msg.sender].balance -= withdrawAmount;
            msg.sender.transfer(withdrawAmount);
        }

        return accounts[msg.sender].balance;
    }
    
    /// @notice send eth to external address
    /// @return balance
     function send(uint256 amount, address payable recipient) public returns (uint256 balance, uint256 invested) {
        uint256 amount_to_borrow;
         
        if (amount <= accounts[msg.sender].balance) {
            accounts[msg.sender].balance -= amount;
            recipient.transfer(amount);
        }
        // We don't have enough money.
        else {
            // Find out the amount we need
            amount_to_borrow = amount - accounts[msg.sender].balance;

            //  Do we have enough money in the investment account?
            if (accounts[msg.sender].invested > amount_to_borrow) {
                // Get amount needed from AAVE
                // aToken.redeem(amount_to_borrow);
                accounts[msg.sender].invested -= amount_to_borrow;
                accounts[msg.sender].balance += amount_to_borrow;
                recipient.transfer(amount);
            } 
        }

        // Topup functionality. If balance is below minBalance get money back from AAVE
        if (accounts[msg.sender].balance < accounts[msg.sender].minBalance) {
            amount_to_borrow =  accounts[msg.sender].minBalance - accounts[msg.sender].balance;
            // Get amount needed from AAVE
            // aToken.redeem(amount_to_borrow);
            accounts[msg.sender].invested -= amount_to_borrow;
            accounts[msg.sender].balance += amount_to_borrow;
        }
        return (accounts[msg.sender].balance, accounts[msg.sender].invested);
    }

    /// @notice Just reads balance of the account requesting, so "constant"
    /// @return The balance of the user
    function balance() public view returns (uint256) {
        return accounts[msg.sender].balance;
    }
    
    /// @notice Set investment threshold
    /// @return investmentThresholdSet
    function setInvestmentThreshold(uint256 investmentThreshold) 
        public 
        returns (uint256 investmentThresholdSet) 
    {
        accounts[msg.sender].investmentThreshold = investmentThreshold;
        return accounts[msg.sender].investmentThreshold;
    }
    
    /// @notice reads the get investmentThreshold 
    /// @return investmentThreshold
    function getInvestmentThreshold()
    public view returns (uint256) {
        return accounts[msg.sender].investmentThreshold;
    }

    /// @notice reads the get investment
    /// @return investment
    function getInvestmentBalance()
    public view returns (uint256) {
        // AAVE Investment Balance
        // return lendingPool.getUserReserveData(underlying_asset, msg.sender)
        return accounts[msg.sender].invested;
    }
    
    /// @notice Set minBalance 
    /// @return minBalanceSet
    function setMinBalance(uint256 minBalance) 
        public 
        returns (uint256 minBalanceSet) 
    {
        accounts[msg.sender].minBalance = minBalance;
            return accounts[msg.sender].minBalance;
    }
    
    /// @notice reads the set minBalance 
    /// @return minBalance
    function getMinBalance()
    public view returns (uint256) {
        return accounts[msg.sender].minBalance;
    }

    /// @return The balance of the Simple Bank contract
    function depositsBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
