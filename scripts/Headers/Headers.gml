/// @desc Wrapper for struct containing HTTP headers
/// @param {array<Struct.Header>} headers
function Headers(headers = []) constructor {
	
	/// @ignore
	self._headers = {};
	
	// add the initial headers
	var headers_len = array_length(headers);
	for (var i = 0; i < headers_len; i ++) {
		self._headers[headers[i].key] = headers[i].val;
	}
	
	/// @desc Add or modify a header
	/// @param {Id.Header} header
	function add(header) {
		self._headers[header.key] = header.val;
	}
	
	/// @desc Remove a header
	/// @param {string} header
	function remove(header) {
		delete self._headers[header];
	}
}

/// @desc A HTTP header
function Header(key, val) constructor {
	self.key = key;
	self.val = val;
}