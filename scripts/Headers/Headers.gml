/// @desc Wrapper for struct containing HTTP headers
/// @param {array<Struct.Pair>} headers
function Headers(headers = []) constructor {
	
	/// @ignore
	self._headers = {
		"content-type": "text/html" // default to HTML content
	};
	
	// add the initial headers
	var headers_len = array_length(headers);
	for (var i = 0; i < headers_len; i ++) {
		self._headers[$ string_lower(headers[i].first)] = headers[i].second;
	}
	
	/// @desc Get a header value by its name
	/// @param {string} header
	/// @return {string|undefined}
	static get = function (header) {
		return self._headers[$ string_lower(header)];
	}
	
	/// @desc Add or modify a header
	/// @param {Struct.Pair} header
	static set = function (header) {
		self._headers[$ string_lower(header.first)] = header.second;
	}
	
	/// @desc Remove a header
	/// @param {string} header
	static remove = function (header) {
		delete self._headers[$ string_lower(header)];
	}
	
	/// @ignore
	/// @desc Set the Content-Length based on the size of body buffer
	/// @param {Id.Buffer} body
	static _set_content_length = function (body) {
		set(new Pair("Content-Length", string(buffer_get_size(body))));
	}
	
	/// @desc Set the Content-Type
	/// @param {string} content_type
	static _set_content_type = function (content_type) {
		set(new Pair("Content-Type", content_type));
	}
	
	/// @desc Get the Content-Type
	static type = function () {
		get("Content-Type");
	}
	
	static toString = function () {
		var str = "";
		var names = struct_get_names(self._headers);
		var names_len = array_length(names);
		
		for (var i = 0; i < names_len; i ++) {
			str += $"{names[i]}: {self._headers[$ names[i]]}\r\n";
		}
		
		return str;
	}
}