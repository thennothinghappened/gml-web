/// @param {Id.Buffer} buf
/// @param {string} ip
/// @param {Struct.GMServer|undefined} app
/// @returns {Struct.Request}
function http_parse_request(buf, ip, app = undefined){
	
	var _text = buffer_read(buf, buffer_text);
	
	// Separate headers from body
	var _req = string_split(_text, "\r\n\r\n");
	var _headers = string_split(array_shift(_req), "\r\n");
	
	// HTTP method string & path
	var _method_string = string_split(array_shift(_headers), " ");
	
	var http_method = _method_string[0];
	var path = _method_string[1];
	var http_version = string_split(_method_string[2], "/")[1];
	
	var headers = array_map(_headers, function(h) {
		var split = string_split(h, ": ",, 1);
		return new Pair(split[0], split[1]);
	});
	
	var body = undefined;
	
	// The only methods which have bodies all start with P!
	if (string_starts_with(http_method, "P")) {
		body = array_join("", _req);
	}
	
	return new Request(app, path, http_method, http_version, ip, new Headers(headers), body);
}