use fmt;

export fn mul(a: bignum, b: bignum) bignum = {
	if (equals(a, zero) || equals(b, zero)) {
		const z: bignum = alloc([0]);
		return z;
	};

	let mul_results: []bignum = [];
	defer for (let r .. mul_results) {
		free(r);
	};

	// Our left/right or top/bottom operands in our multiplication.
	// Shortest goes on the bottom.
	const operands = if (len(a) > len(b)) (a, b) else (b, a);

	for (let i = len(operands.1) - 1; i >= 0 && i < len(operands.1); i -= 1) {
		const mul_result = new(len(operands.0) + i + 1);
		append(mul_results, mul_result);

		let carry: digit = 0;
		for (let j = len(operands.0) - 1; j >= 0 && j < len(operands.0); j -= 1) {
			const inc_carry: digit = if (carry != 0) 1 else 0;
			const res = operands.0[j] * operands.1[i] + inc_carry;
			carry = if (res > 9) res else 0;
			mul_result[j + 1] = res % 10;
		};

		if (carry != 0) {
			// Last mul_result has nowhere to carry to.
			mul_result[0] = carry / 10: digit;
		};
	};

	const c = new(len(a) + len(b));
	for (let mr .. mul_results) {
		const x = add(c, mr);
		free(c); // We don't need the previous "c".
		c = x;
	};

	return c;
};

@test fn single_digit_mul() void = {
	const a = from_string("8")!;
	defer free(a);
	const b = from_string("7")!;
	defer free(b);

	const c = mul(a, b);
	defer free(c);

	const want = from_string("56")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn simple_10s() void = {
	const one = from_string("1")!;
	defer free(one);
	const ten = from_string("10")!;
	defer free(ten);
	const hundred = from_string("100")!;
	defer free(hundred);
	const thousand = from_string("1000")!;
	defer free(thousand);

	const pairs = [
		(one, ten, ten),
		(ten, ten, hundred),
		(ten, hundred, thousand),
		(one, hundred, hundred)
	];

	for (let p .. pairs) {
		const res = mul(p.0, p.1);
		defer free(res);
		assert(equals(res, p.2));
	};
};
