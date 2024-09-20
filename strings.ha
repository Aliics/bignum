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
