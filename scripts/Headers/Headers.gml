/// @desc Wrapper for struct containing HTTP headers
/// @param {array<Struct.Pair>} headers
function Headers(headers = []) constructor {
	
	/// @ignore
	self._headers = {};
	
	// add the initial headers
	var headers_len = array_length(headers);
	for (var i = 0; i < headers_len; i ++) {
		self._headers[$ headers[i].first] = headers[i].second;
	}
	
	/// @desc Add or modify a header
	/// @param {Id.Header} header
	function add(header) {
		self._headers[$ header.first] = header.second;
	}
	
	/// @desc Remove a header
	/// @param {string} header
	function remove(header) {
		delete self._headers[$ header];
	}
}