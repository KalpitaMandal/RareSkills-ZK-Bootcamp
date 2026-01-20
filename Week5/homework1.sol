// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ECC_pairings {
    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    // Using field_modulus, because we are operating on the (x,y) coordinates instead of points
    uint256 FIELD_MODULUS = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den) public view returns (bool verified) {
        (uint C_x, uint C_y) = add(A.x, A.y, B.x, B.y);

        // Calculating if (C_x / C_y) == (num / den) mod p
        uint256 C_y_inv = modExp(C_y, FIELD_MODULUS - 2, FIELD_MODULUS);
        uint256 lhs = mulmod(C_x, C_y_inv, FIELD_MODULUS);

        uint256 den_inv = modExp(den, FIELD_MODULUS - 2, FIELD_MODULUS);
        uint256 rhs = mulmod(num, den_inv, FIELD_MODULUS);
        verified = lhs == rhs;
    }

    function modExp(uint256 base, uint256 exp, uint256 mod) public view returns (uint256) { 
        bytes memory precompileData = abi.encode(32, 32, 32, base, exp, mod);
        (bool ok, bytes memory data) = address(5).staticcall(precompileData);
        require(ok, "expMod failed");
        return abi.decode(data, (uint256));
    }

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