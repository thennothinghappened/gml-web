/// @desc Wrapper for struct containing HTTP headers
/// @param {array<Id.Header>} headers
function Headers(headers = []) constructor {
	
	self.__headers__ = {};
	
	// add the initial headers
	var headers_len = array_length(headers);
	for (var i = 0; i < headers_len; i ++) {
		self.__headers__[headers[i].key] = headers[i].val;
	}
	
	/// @desc Add or modify a header
	/// @param {Id.Header} header
	function add(header) {
		self.__headers__[header.key] = header.val;
	}
	
	/// @desc Remove a header
	/// @param {string} header
	function remove(header) {
		delete self.__headers__[header];
	}
}

/// @desc A HTTP header
function Header(key, val) constructor {
	self.key = key;
	self.val = val;
}