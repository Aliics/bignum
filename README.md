# hare - bignum

bignum math in hare. Representation of a `bignum` is just an array of bytes,
which I have aliased to be a `digit`. So, a sequence of digits...

Anyways, most algorithms using bignums in this implementations are linear time,
which means math operations are much more expensive than your usual integer
operations, which are constant time and very cheap. If you were looking at this
library anyway, you likely new that.

Have a look at the `haredoc` and start mathing away. :D
