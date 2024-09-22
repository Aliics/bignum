// Multiply two [[bignum]]s together.
// This is implemented as long multiplication, so it's likely not very efficient.
// This should be approximately O(Rn * Ln + Ln) time complexity.
export fn mul(a: bignum, b: bignum) bignum = {
	if (equals(a, zero) || equals(b, zero)) {
		const z: bignum = alloc([0]);
		return z;
	};

	let mul_results: []bignum = [];
	defer for (let r .. mul_results) {
		free(r);
	};

	const pa = a[padding_end(a)..];
	const pb = b[padding_end(b)..];

	// Our left/right or top/bottom operands in our multiplication.
	// Shortest goes on the bottom.
	const ops = if (len(pa) > len(pb)) (pa, pb) else (pb, pa);

	const llen = len(ops.0);
	const rlen = len(ops.1);
	for (let i = rlen - 1; i >= 0 && i < rlen; i -= 1) {
		const mul_result = new(llen + rlen);
		append(mul_results, mul_result);

		let carry: digit = 0;
		for (let j = llen - 1; j >= 0 && j < llen; j -= 1) {
			const inc_carry: digit = if (carry != 0) 1 else 0;
			const res = ops.0[j] * ops.1[i] + inc_carry;
			carry = if (res > 9) res else 0;
			mul_result[j + i + 1] = res % 10;
		};

		if (carry != 0) {
			// Last mul_result has nowhere to carry to.
			mul_result[i] = carry / 10: digit;
		};
	};

	const c = new(llen + rlen);
	for (let mr .. mul_results) {
		const x = add(c, mr);
		free(c); // We don't need the previous "c".
		c = x;
	};

	return c;
};

@test fn mul_zero() void = {
	const a = from_string("420")!;
	defer free(a);

	const c = mul(a, zero);
	defer free(c);

	assert(equals(c, zero));
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

@test fn simple_10s_mul() void = {
	const one = from_string("1")!;
	defer free(one);
	const ten = from_string("10")!;
	defer free(ten);
	const hundred = from_string("100")!;
	defer free(hundred);
	const thousand = from_string("1000")!;
	defer free(thousand);
	const ten_thousand = from_string("10000")!;
	defer free(ten_thousand);

	const pairs = [
		(one, ten, ten),
		(ten, ten, hundred),
		(one, hundred, hundred),
		(ten, hundred, thousand),
		(one, thousand, thousand),
		(ten, thousand, ten_thousand)
	];

	for (let p .. pairs) {
		const res = mul(p.0, p.1);
		defer free(res);
		assert(equals(res, p.2));
	};
};

@test fn large_number_multiplication() void = {
	const a = from_string("2031")!;
	defer free(a);
	const b = from_string("921923")!;
	defer free(b);

	const c = mul(a, b);
	defer free(c);

	const want = from_string("1872415613")!;
	defer free(want);
	assert(equals(c, want));
};
