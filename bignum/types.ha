// Representation of all the digits in a bignum.
// Each digit is it's own byte, a [[digit]], which is a type alias for a [[u8]].
export type bignum = []digit;

// Byte representing a number (0 .. 9).
export type digit = u8;

export type invalid = !void;
