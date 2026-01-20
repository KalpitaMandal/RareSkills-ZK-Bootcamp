// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ECC_pairings {
    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    // BN254 generator point G
    uint256 constant G_X = 1;
    uint256 constant G_Y = 2;

    function matmul(uint256[] calldata matrix,
                    uint256 n, // n x n for the matrix
                    ECPoint[] calldata s, // n elements
                    uint256[] calldata o // n elements
                ) public view returns (bool verified) {

        // revert if dimensions don't make sense or the matrices are empty
        if(matrix.length != n * n || s.length != n || o.length != n) {
            revert("Dimensions not correct");
        }

        for(uint i = 0; i < n ; i++) {
            uint lhs_x = 0;
            uint lhs_y = 0;
            
            for (uint j = 0; j < n; j++) {
                uint scalar = matrix[i * n + j];
                (uint mul_x, uint mul_y) = multiply(s[j].x, s[j].y, scalar);
                (lhs_x, lhs_y) = add(lhs_x, lhs_y, mul_x, mul_y);
            }

            (uint rhs_x, uint rhs_y) = multiply(G_X, G_Y, o[i]);

            if (lhs_x != rhs_x || lhs_y != rhs_y) {
                return false;
            }
        }
        return true;
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