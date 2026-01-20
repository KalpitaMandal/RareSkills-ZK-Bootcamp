// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ECC_pairings {

    function add(uint x1, uint y1, uint x2, uint y2) public view returns(uint x3, uint y3) {
        bytes memory payload = abi.encode(x1, y1, x2, y2);
        (bool ok, bytes memory ans) = address(6).staticcall(payload);
        require(ok);
        return abi.decode(ans, (uint, uint));
    }

    function multiply(uint x1, uint y1, uint scalar) public view returns(uint x2, uint y2) {
        bytes memory payload = abi.encode(x1, y1, scalar);
        (bool ok, bytes memory ans) = address(7).staticcall(payload);
        require(ok);
        return abi.decode(ans, (uint, uint));
    }
}