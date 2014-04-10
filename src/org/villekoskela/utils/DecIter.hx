package org.villekoskela.utils;
class DecIter {
	var now:Int;
	var limit:Int;
	inline public function new(max:Int, min:Int) {
		now = max;
		limit = min;
	}
	inline public function hasNext() { return (now >= limit); }
	inline public function next() { return now--; }
}