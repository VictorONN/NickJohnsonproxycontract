//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

abstract contract Upgradeable {
    mapping(bytes4 => uint32) _sizes;
    address _dest;

    function initialize() public virtual;

    function replace(address target) public {
        _dest = target;
        target.delegateCall(
            abi.encodeWithSelector(bytes4(keccak256("initialize()")))
        );
    }
}

contract Dispatcher is Upgradeable {
    constructor(address target) {
        replace(target);
    }

    function initialize() public override {
        //should only be called by on target contracts, not on the dispatcher
        assert(false);
    }

    fallback() external {
        bytes4 sig;
        assembly {
            sig := calldataload(0)
        }
        uint256 len = _sizes[sig];
        address target = _dest;

        assembly {
            //return _dest.delegateCall(msg.data)
            calldatacopy(0x0, 0x0, calldatasize())
            let result := delegatecall(
                sub(gas(), 1000),
                target,
                0x0,
                calldatasize(),
                0,
                len
            )
            return(0, len) // we throw away any data
        }
    }
}

//logic smart contract
contract Example is Upgradeable {
    uint256 _value;

    function initialize() public override {
        _sizes[bytes4(keccak256("getUint()"))] = 32;
    }

    function getUint() public view returns (uint256) {
        return _value;
    }

    function setUint(uint256 value) public {
        _value = value;
    }
}
