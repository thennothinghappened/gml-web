/// @desc An incoming HTTP request
/// @param {Id.Buffer} data
/// @param {string} ip
/// @param {Struct.GMServer} app
function Request(data, ip, app) constructor {
	
	self.app = app;
	self.ip = ip;
	
	///////////////////////////
	//// parse the request ////
	///////////////////////////
	
	var _text = buffer_read(data, buffer_text);
	
	// Separate headers from body
	var _req = string_split(_text, "\r\n\r\n");
	var _headers = string_split(array_shift(_req), "\r\n");
	
	// HTTP method string & path
	var _method_string = string_split(array_shift(_headers), " ");
	
	self.http_method = _method_string[0];
	self.original_path = http_decode_characters(_method_string[1]);
	self.http_version = string_split(_method_string[2], "/")[1];
	
	// Parse the path
	var path_and_query = string_split(_method_string[1], "?",, 1);
	self.path = http_decode_characters(path_and_query[0]);
	self.query = {};
	
	// Parse the query string if it exists
	if (array_length(path_and_query) > 1) {
		var query_string = string_split(http_decode_characters(path_and_query[1]), "&");
		array_foreach(query_string, function(param) {
			try {
				var key_val = string_split(param, "=",, 1);
				if (array_length(key_val) == 1) {
					key_val[1] = "";
				}
					
				self.query[$ key_val[0]] = key_val[1];
			} catch (err) {}
		});
	}
	
	// Parse the headers
	var _headers_split = array_map(_headers, function(h) {
		var split = string_split(h, ": ",, 1);
		return new Pair(split[0], split[1]);
	});
	
	self.headers = new Headers(_headers_split);
	
	var body = undefined;
	
	// The only methods which have bodies all start with P!
	if (string_starts_with(http_method, "P")) {
		self._body = array_join("", _req);
	}
	
	/// @ignore
	self._body = body;
	self.body = undefined;
	
	static type = function () {
		return self.headers.type();
	}
}