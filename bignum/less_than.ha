export fn less_than(a: bignum, b: bignum) bool = {
	const pa = a[padding_end(a)..];
	const pb = b[padding_end(b)..];

	if (len(pa) < len(pb)) {
		// It has less digits, easy.
		return true;
	} else if (len(pa) > len(pb)) {
		// It has more digits, also easy.
		return false;
	};

	for (let i = 0z; i < len(pa); i += 1) {
		if (pa[i] < pb[i]) {
			return true;
		};
	};

	return false; // Probably equal then.
};

@test fn one_is_less_than_two() void = {
	const a = from_string("1")!;
	defer free(a);
	const b = from_string("2")!;
	defer free(b);

	assert(less_than(a, b));
};

@test fn equal_numbers_not_less_than() void = {
	const a = from_string("120")!;
	defer free(a);
	const b = from_string("120")!;
	defer free(b);

	assert(!less_than(a, b));
};

@test fn not_less_than_it_is_slightly_more() void = {
	const a = from_string("121")!;
	defer free(a);
	const b = from_string("120")!;
	defer free(b);

	assert(!less_than(a, b));
};
