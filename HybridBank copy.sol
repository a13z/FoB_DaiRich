pragma solidity ^0.5.0;

import "@nomiclabs/buidler/console.sol";
//import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./aave/interfaces/ILendingPool.sol";
import "./aave/interfaces/ILendingPoolAddressesProvider.sol";
//import "./aave/tokenization/AToken.sol";
//import "./aave/lendingpool/LendingPool.sol";
//import "./aave/libraries/WadRayMath.sol";
//import "./Calendar.sol";

// AAVE required interfaces
//interface LendingPoolAddressesProvider {
//    function getLendingPool() external view returns (address);
//}
//
//interface LendingPool {
//    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
//    function getReserveConfigurationData(address _reserve) external;
//    function getUserReserveData(address _reserve, address _user) external;
//}
//
//interface AToken {
//    function redeem(uint256 _amount) external;
//}

contract HybridBank is Ownable {
    uint8 private clientCount;
    struct Account {
        // Not needed since we can use ERC20 balance function to retrieve the balance
        // uint256 balance;        // Initially this will be amount in DAI. We should allow other tokens too
        // uint256 aToken_balance; // This is the amount of aDai received from AAVE after depositing (investing) DAI
        uint256 investmentThreshold;
        uint256 minBalance;
        uint256 invested;

        uint borrowedBalance;
        uint liquidityBalance;
        uint borrowAccruedInterestUntilLastUpdate;
        uint lastUpdated;
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
    ILendingPool public lendingPool;

    // Log the event about a deposit being made by an address and its amount
    // event LogDepositMade(address indexed accountAddress, uint256 amount);
    event LogLendingPool(ILendingPoolAddressesProvider lendingPoolAddressProvider, ILendingPool lendingPool);
    event LogInvestmentMade(address indexed accountAddress, uint256 amount);

    // Constructor is "payable" so it can receive the initial funding of 30,
    // required to reward the first 3 clients
    // Ropsten details
    // LendingPool AddressesProvider 0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728
    // aToken instance 0x2433A1b6FcF156956599280C3Eb1863247CFE675
    // aDai asset address 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108
    // aETH asset address 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    // Dai smart contract 0x580D4Fdc4BF8f9b5ae2fb9225D584fED4AD5375c
    // Kovan details
    // LendingPool 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5
    // DAI: https://kovan.etherscan.io/address/0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD
    // aDAI: https://kovan.etherscan.io/address/0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a

    constructor(IERC20 _inboundCurrency,
                IERC20 _interestCurrency,
                ILendingPoolAddressesProvider _lendingPoolAddressesProvider
                )
                public {

        daiToken = _inboundCurrency;
        adaiToken = _interestCurrency;

        /// Initialise AAVE
        /// Retrieve LendingPool address
        lendingPoolAddressProvider = ILendingPoolAddressesProvider(_lendingPoolAddressesProvider);
        lendingPool = ILendingPool(lendingPoolAddressProvider.getLendingPool());

        emit LogLendingPool(lendingPoolAddressProvider, lendingPool);

      }

    function approveERC20ToAave() public {
        // Allow lending pool convert DAI deposited on this contract to aDAI on lending pool
        uint MAX_ALLOWANCE = 2**256 - 1;
        daiToken.approve(address(lendingPool), MAX_ALLOWANCE);
    }

    function balanceOf() public view returns (uint256) {
        return daiToken.balanceOf(msg.sender);
    }

    function balanceOfInterest() public view returns(uint256) {
        return adaiToken.balanceOf(msg.sender);
    }

    function invest(uint256 _amount) public returns (uint256, uint256) {
        lendingPool.deposit(address(daiToken), _amount, 0);

        emit LogInvestmentMade(msg.sender, _amount);

        return (daiToken.balanceOf(msg.sender), adaiToken.balanceOf(msg.sender));
    }

    /// @notice Deposit ether into bank, requires method is "payable"
    /// @return The balance of the user after the deposit is made
    function deposit(uint256 _amount) public payable returns (uint256, uint256) {
//        uint256 amount_to_invest;
        // Add deposit amount to balance
//        accounts[msg.sender].balance += _amount;

        // If current balance is higher than investmentThresdhold
//        if ((accounts[msg.sender].investmentThreshold > 0) && (accounts[msg.sender].balance > accounts[msg.sender].investmentThreshold))  {
//            amount_to_invest = accounts[msg.sender].balance - accounts[msg.sender].investmentThreshold;
            // Deposit the Money to a AAVE lendingPool
            // lendingPool.deposit(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, amount_to_invest , referral);

//            ILendingPool lendingPool = ILendingPool(lendingPoolAddressProvider.getLendingPool());

//            require(daiToken.allowance(whose, address(this)) >= amount, "You need to have allowance to do transfer DAI on the smart contract");

            // Move DAI from user wallet to this contract
//            require(daiToken.transferFrom(whose, address(this), amount) == true, "Transfer failed");

            // https://developers.aave.com/#lendingpool
            // https://github.com/aave/aave-protocol/blob/master/test/atoken-transfer.spec.ts#L39

            // Move DAI form this contract to lending pool
            // See approve() in the constructor
//            lendingPool.deposit(address(daiToken), amount_to_invest, 0);
//            accounts[msg.sender].invested += amount_to_invest;
//            accounts[msg.sender].balance -= amount_to_invest;
//        }

        lendingPool.deposit(address(daiToken), _amount, 0);


//        emit LogDepositMade(msg.sender, msg.value);
//        return (accounts[msg.sender].balance, accounts[msg.sender].invested);
        return (daiToken.balanceOf(msg.sender), adaiToken.balanceOf(msg.sender));
    }

    /// @notice Withdraw ether from bank
    /// @return remainingBal The balance remaining for the user
//    function withdraw(uint256 withdrawAmount)
//        public
//        returns (uint256 remainingBal)
//    {
//        // Check enough balance available, otherwise just return balance
////        if (withdrawAmount <= accounts[msg.sender].balance) {
////            accounts[msg.sender].balance -= withdrawAmount;
////            msg.sender.transfer(withdrawAmount);
////        }
//
//        return (daiToken.balanceOf(msg.sender), adaiToken.balanceOf(msg.sender));
//    }
    
    /// @notice send eth to external address
    /// @return balance
//     function send(uint256 amount, address payable recipient) public returns (uint256 balance, uint256 invested) {
//        uint256 amount_to_borrow;
//
//        if (amount <= accounts[msg.sender].balance) {
//            accounts[msg.sender].balance -= amount;
//            recipient.transfer(amount);
//        }
//        // We don't have enough money.
//        else {
//            // Find out the amount we need
//            amount_to_borrow = amount - accounts[msg.sender].balance;
//
//            //  Do we have enough money in the investment account?
//            if (accounts[msg.sender].invested > amount_to_borrow) {
//                // Get amount needed from AAVE
//                // aToken.redeem(amount_to_borrow);
//                accounts[msg.sender].invested -= amount_to_borrow;
//                accounts[msg.sender].balance += amount_to_borrow;
//                recipient.transfer(amount);
//            }
//        }
//
//        // Topup functionality. If balance is below minBalance get money back from AAVE
//        if (accounts[msg.sender].balance < accounts[msg.sender].minBalance) {
//            amount_to_borrow =  accounts[msg.sender].minBalance - accounts[msg.sender].balance;
//            // Get amount needed from AAVE
//            // aToken.redeem(amount_to_borrow);
//            accounts[msg.sender].invested -= amount_to_borrow;
//            accounts[msg.sender].balance += amount_to_borrow;
//        }
//        return (accounts[msg.sender].balance, accounts[msg.sender].invested);
//    }

    /// @notice Just reads balance of the account requesting, so "constant"
    /// @return The balance of the user
    function balance() public view returns (uint256) {
        return daiToken.balanceOf(msg.sender);
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

}
