// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Circle 2D Library
 * @author Sirawit Techavanitch
 */

library Circle2D {
    struct Circle {
        int32 x;
        int32 y;
        uint16 r;
    }

    uint16 private constant PI = 314;
    uint8 private constant TWO = 2;

    function point(Circle storage self) internal view returns (int32, int32) {
        return (self.x, self.y);
    }

    function area(Circle storage self) internal view returns (uint64) {
        return PI * (self.r ** TWO);
    }

    function diameter(Circle storage self) internal view returns (uint64) {
        return TWO * self.r;
    }

    function radius(Circle storage self) internal view returns (uint16) {
        return self.r;
    }

    function circumference(Circle storage self) internal view returns (uint64) {
        return (TWO * PI) * self.r;
    }

    function contain(Circle storage self, Circle memory circle) internal view returns (bool) {
        // @TODO
        // uint value = Math.sqrt(((self.x - circle.x) ** TWO) + (self.y - self.y ** TWO));
        // value + circle.r == self.r
        // if (value + circle.r <= self.r) return true;
        return false;
    }

    function overlap(Circle storage self, Circle memory circle) internal view returns (bool) {
        // @TODO
        // not lie completely touch the circumference or intersection only
        return false;
    }
}
