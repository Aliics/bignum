use fmt;

fn padding_end(bn: bignum) size = {
	// Accomodate for zero values.
	if (len(bn) == 0 || len(bn) == 1) {
		return 0;
	};

	// There is no padding.
	if (bn[0] != 0) {
		return 0;
	};

	let i = 0z;
	for (i < len(bn); i += 1) {
		if (bn[i] != 0) {
			break;
		};
	};

	return i;
};

@test fn multiple_bytes_padding() void = {
	const bn: bignum = [0, 0, 0, 2];

	assert(padding_end(bn) == 3);
};

@test fn no_padding() void = {
	const bn: bignum = [2];

	assert(padding_end(bn) == 0);
};

@test fn single_byte_padding() void = {
	const bn: bignum = [0, 2, 0];

	assert(padding_end(bn) == 1);
};
