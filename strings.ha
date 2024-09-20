use strings;

// Converts each run to a [[digit]].
// We ensure the rune is in between the digit range, otherwise we return an
// [[invalid]] error.
export fn from_string(s: str) (bignum | invalid) = {
	const cs = strings::toutf8(s);
	const bn: bignum = alloc([0...], len(s));
	for (let i = 0z; i < len(cs); i += 1) {
		const c = cs[i];
		if (c < 48 || c > 57) {
			free(bn);
			return invalid;
		};
		bn[i] = c - 48;
	};
	return bn;
};

@test fn from_string_happy_path() void = {
	const bn = from_string("31415")!;
	defer free(bn);

	assert(bn[0] == 3);
	assert(bn[1] == 1);
	assert(bn[2] == 4);
	assert(bn[3] == 1);
	assert(bn[4] == 5);
};

@test fn from_string_invalid() void = {
	assert(from_string("3a") is invalid);
};

// Converts a [[bignum]] to a utf8 string.
// There is an assumption that this bignum is constructed correctly, and the
// digits are all within the validation numeric range.
export fn string(bn: bignum) str = {
	// Remove padding prefix.
	const p = bn[padding_end(bn)..];

	const bs: []u8 = alloc([0...], len(p));
	for (let i = 0z; i < len(p); i += 1) {
		bs[i] = p[i] + 48;
	};

	// Unless the caller decided to be silly and construct their own...
	// This a safe operation, but you never know. :-/
	return strings::fromutf8_unsafe(bs);
};

@test fn string() void = {
	const a = from_string("3742")!;
	defer free(a);

	const s = string(a);
	defer free(s);

	assert(s == "3742");
};
