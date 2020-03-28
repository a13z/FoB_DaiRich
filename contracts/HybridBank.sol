pragma solidity ^0.5.0;


import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./aave/interfaces/ILendingPool.sol";
import "./aave/interfaces/ILendingPoolAddressesProvider.sol";

contract HybridBank is Ownable {
    uint private clientCount;
    uint private totalDeposits;
    uint private totalInvested;

    struct Account {
        // Not needed since we can use ERC20 balance function to retrieve the balance
        uint256 balance;        // Initially this will be amount in DAI. We should allow other tokens too
        // uint256 aToken_balance; // This is the amount of aDai received from AAVE after depositing (investing) DAI
        uint256 investmentThreshold;
        uint256 minBalance;
        uint256 invested;
        bool isEnrolled;
    }
    mapping(address => Account) private accounts;

    // DAI Token used by the account
    IERC20 daiToken;
    // AAVE variables
    // aToken aDAI aToken receiving interests
    IERC20 adaiToken;

    uint16 private referral;
    // DAI for the time being
    address underlyingAsset;

//    TODO: Check this later
//    using SafeERC20 for IERC20;
//    using SafeMath for uint256;

    // Retrieve LendingPool address from
    // https://github.com/masaun/prediction-ticket/blob/master/contracts/StakingByAToken.sol

    /// Retrieve LendingPool address
    ILendingPoolAddressesProvider public lendingPoolAddressProvider;
        //    address public lendingPoolCore;

    // Log the event about a deposit being made by an address and its amount
    event LogDepositMade(address indexed accountAddress, uint256 amount);
    event LogLendingPoolCore(address lendingPoolCore);
    event LogLendingPool(ILendingPool lendingPoolAddressProvider);
    event LogInvestmentMade(address indexed accountAddress, uint256 amount);
    event LogApproveERC20ToAAVE(address indexed from, address indexed to, IERC20 token);

    modifier isEnrolled() {
        require(
            accounts[msg.sender].isEnrolled,
            "Address must be enrolled in the bank"
        );
        _;
    }
    // Kovan details
    // LendingPoolCore 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45
    // LendingPool 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5
    // DAI: https://kovan.etherscan.io/address/0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD
    // aDAI: https://kovan.etherscan.io/address/0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a

    constructor(ILendingPoolAddressesProvider _lendingPoolAddressesProvider,
                IERC20 _inboundCurrency,
                IERC20 _interestCurrency
                )
                public {

        daiToken = _inboundCurrency;
        adaiToken = _interestCurrency;
        lendingPoolAddressProvider = _lendingPoolAddressesProvider;

        // Initialise variables
        clientCount = 0;
        totalDeposits = 0;
        totalInvested = 0;

        // Allow lending pool convert DAI deposited on this contract to aDAI on lending pool
        address lendingPoolCore = lendingPoolAddressProvider.getLendingPoolCore();
        emit LogLendingPoolCore(lendingPoolCore);

        uint MAX_ALLOWANCE = 2**256 - 1;
        daiToken.approve(lendingPoolCore, MAX_ALLOWANCE);
        emit LogApproveERC20ToAAVE(msg.sender, lendingPoolCore, daiToken);
      }

    /// @notice Enroll a customer with the bank,
    /// @return The balance of the user after enrolling
    function enroll() public {
        accounts[msg.sender].isEnrolled = true;
        accounts[msg.sender].balance = 0;
        accounts[msg.sender].invested = 0;
        clientCount++;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit(uint256 _amount)
        public
        isEnrolled
        returns (uint256, uint256) {

        uint256 amountToInvest;

        // Check allowance from DAI contract to transfer DAI to this contract
        require(daiToken.allowance(msg.sender, address(this)) >= _amount, "You need to have allowance to do transfer DAI on this smart contract");

        // Move DAI from user wallet to HybridBank
        require(daiToken.transferFrom(msg.sender, address(this), _amount) == true, "Transfer failed");

        // Add deposit amount to balance
        accounts[msg.sender].balance += _amount;

        totalDeposits += _amount;

        // If current balance is higher than investmentThresdhold
        if ((accounts[msg.sender].investmentThreshold > 0) && (accounts[msg.sender].balance > accounts[msg.sender].investmentThreshold))  {
            amountToInvest = accounts[msg.sender].balance - accounts[msg.sender].investmentThreshold;
            _investInAAVE(amountToInvest);
        }

        emit LogDepositMade(msg.sender, _amount);
        return (accounts[msg.sender].balance, accounts[msg.sender].invested);
    }


    function _investInAAVE(uint256 _amount) internal {
        ILendingPool lendingPool = ILendingPool(lendingPoolAddressProvider.getLendingPool());

        emit LogLendingPool(lendingPool);

        lendingPool.deposit(address(daiToken), _amount, 0);
        accounts[msg.sender].invested += _amount;
        accounts[msg.sender].balance -= _amount;
        totalInvested += _amount;

        emit LogInvestmentMade(msg.sender, _amount);

    }

    /// @notice Just reads balances of the account requesting, so "constant"
    /// @return The balance of the user, amount deposited, invested and invested plus interests
    function balance()
        public view
        isEnrolled
        returns (uint256, uint256, uint256) {

        uint256 percentageInvested;
        uint256 investedWithInterests;
        if (accounts[msg.sender].invested > 0) {
            percentageInvested = accounts[msg.sender].invested / totalInvested;
            investedWithInterests = adaiToken.balanceOf(address(this)) * percentageInvested;
        }
        else
        {
            investedWithInterests = 0;
        }
        return (accounts[msg.sender].balance, accounts[msg.sender].invested, investedWithInterests);
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
        public view
        returns (uint256) {
        return accounts[msg.sender].minBalance;
    }

    /// @notice reads the Total amount deposited in the Hybrid Bank
    /// @return totalDeposits
    function getTotalDeposits()
        public view
        returns (uint256) {
        return totalDeposits;
    }

    /// @notice reads the Total amount invested in AAVE without interests
    /// @return totalDeposits
    function getTotalInvested()
        public view
        returns (uint256) {
        return totalInvested;
    }

    /// @notice reads the Hybrid Bank DAI balance
    /// @return DAI balance
    function getContractDAIBalance()
        public view
        returns (uint256) {
        return daiToken.balanceOf(address(this));
    }

    /// @notice Just reads balances of the aDai token
    /// @return The balance of the total amount invested in AAVE with interests
    function getContractAAVEBalance()
        public view
        onlyOwner
        returns(uint256) {
        return adaiToken.balanceOf(address(this));
    }

    /// @notice reads the Hybrid bank clients count
    /// @return clientCount
    function getClientCount()
        public view
        onlyOwner
        returns (uint256) {
        return clientCount;
    }
}
