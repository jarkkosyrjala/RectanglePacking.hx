package org.villekoskela.utils;
class DecIter {
	var now:Int;
	var limit:Int;
	public function new(max:Int, min:Int) {
		now = max;
		limit = min;
	}
	public function hasNext() { return (now >= limit); }
	public function next() { return now--; }
}