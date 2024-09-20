// Compares two bignums, digit-by-digit. This makes it an O(n) computation.
export fn equals(a: bignum, b: bignum) bool = {
	// Compare without the padding, so optionally walk past the first item.
	const pa = if (len(a) > 1 && a[0] == 0) a[1..] else a;
	const pb = if (len(b) > 1 && b[0] == 0) b[1..] else b;

	if (len(pa) != len(pb)) {
		return false;
	};

	for (let i = 0z; i < len(pa); i += 1) {
		if (pa[i] != pb[i]) {
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
