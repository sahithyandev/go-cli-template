// Package binutil provides bounds-safe helpers for reading integers,
// bitfields, and fixed-width strings out of raw byte slices.
//
// The stdlib encoding/binary package already handles endian conversion, but
// it panics when the slice is too short. Binary formats parsed in the wild
// are often truncated or corrupted, so every helper here returns an error
// instead of panicking on out-of-range input.
package binutil
