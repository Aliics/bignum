// Simple digit-by-digit addition.
// This addition is calculated in linear time O(n), where n is the number of
// digits of the largest number.
// [[bignum]] returned from this function is dynamically allocated, so the
// ownership is moved to the caller.
export fn add(a: bignum, b: bignum) bignum = {
	const max = if (len(a) > len(b)) len(a) else len(b);
	const ad = max - len(a);
	const bd = max - len(b);

	const c = new(max + 1);

	let carry = false;
	for (let i = max - 1; i >= 0 && i < max; i -= 1) {
		const ai = i - ad;
		const bi = i - bd;
		const ax: digit = if (len(a) > ai && ai < max) a[ai] else 0;
		const bx: digit = if (len(b) > bi && bi < max) b[bi] else 0;
		const sum = ax + bx + (if (carry) 1 else 0): digit;
		carry = sum > 9;
		c[i + 1] = sum % 10;
	};

	if (carry) {
		c[0] = 1;
	};

	return c;
};

@test fn single_digit_add() void = {
	const a = from_string("1")!;
	defer free(a);
	const b = from_string("2")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("3")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn single_digit_add_with_rollover() void = {
	const a = from_string("8")!;
	defer free(a);
	const b = from_string("3")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("11")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn double_digit_add() void = {
	const a = from_string("83")!;
	defer free(a);
	const b = from_string("11")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("94")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn double_digit_add_with_double_rollover() void = {
	const a = from_string("97")!;
	defer free(a);
	const b = from_string("5")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("102")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn many_digits_with_rollover() void = {
	const a = from_string("99999")!;
	defer free(a);
	const b = from_string("7")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("100006")!;
	defer free(want);
	assert(equals(c, want));
};

@test fn some_very_large_numbers() void = {
	const a = from_string("192383191")!;
	defer free(a);
	const b = from_string("68102847102")!;
	defer free(b);

	const c = add(a, b);
	defer free(c);

	const want = from_string("68295230293")!;
	defer free(want);
	assert(equals(c, want));
};
