//"spdx-License-Identifier : UNLICENSED"
pragma solidity 0.8.0;

// basic contract imported from github openzeppline.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";


    contract CRICFUNToken is ERC20 {
         using SafeMath for uint;
     uint public caps;   
//declaired name of token and token symbol.         
    constructor()ERC20("CRICFUNToken","CFUN") {
        
        // calculation for capped tokens.
        uint initialSupply = 20000 * (10 ** uint(decimals()));
         caps = initialSupply .mul(2);
        _mint(msg.sender,initialSupply);
        
    }
        function generatToken(address account, uint amount)public {
        require(account != address(0), "invalid account");
        require(amount >0,"invalid amount");
        require(totalSupply().add(amount)<caps,"over limit token");
        _mint(account,amount);
        }
        
    }
    contract TimeLocked is CRICFUNToken{
        using SafeERC20 for IERC20;

    // ERC20 basic token contract being held
    IERC20 private immutable _tokenaddress;

    // beneficiary of tokens after they are released
    address private immutable _beneficiaryaddress;

    // timestamp when token release is enabled
    uint256 private immutable _releaseTime;

    
    constructor(IERC20 token_,address beneficiary_,uint256 releaseTime_) {
        
        require(releaseTime_ > block.timestamp, "TokenTimelock: release time is before current time");
        _tokenaddress = token_;
        _beneficiaryaddress = beneficiary_;
        _releaseTime = releaseTime_;
    }

    /**
     * @return the token being held.
     */
    function token() public view virtual returns (IERC20) {
        return _tokenaddress;
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view virtual returns (address) {
        return _beneficiaryaddress;
    }

    /**
     * @return the time when the tokens are released.
     */
        function releaseTime() public view virtual returns (uint256) {
        return _releaseTime;
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release() public payable virtual {
        require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");

        uint256 amount = token().balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        token().safeTransfer(beneficiary(), amount);
    }
}
