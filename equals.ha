// Compares two bignums, digit-by-digit. This makes it an O(n) computation.
export fn equals(a: bignum, b: bignum) bool = {
	if (len(a) != len(b)) {
		return false;
	};

	for (let i = 0z; i < len(a); i += 1) {
		if (a[i] != b[i]) {
			return false;
		};
	};

	return true;
};

@test fn equals() void = {
	const a = from_string("25")!;
	defer free(a);
	const b = from_string("25")!;
	defer free(b);
	const c = from_string("7")!;
	defer free(c);

	assert(equals(a, a));
	assert(equals(a, b));
	assert(!equals(a, c));
	assert(!equals(b, c));
};
