export fn mul(a: bignum, b: bignum) bignum = {
	// wip
	// if (equals(a, zero) || equals(b, zero)) {
		const z: bignum = alloc([0]);
		return z;
	// };


};

@test fn single_digit_mul() void = {
	const a = from_string("8")!;
	defer free(a);
	const b = from_string("7")!;
	defer free(b);

	const c = mul(a, b);
	free(c);

	const want = from_string("56")!;
	defer free(want);
	assert(equals(c, want));
};
