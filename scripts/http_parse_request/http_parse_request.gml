/// @param {Id.Buffer} buf
/// @returns {Struct.Request}
function http_parse_request(buf){
	
	var _text = buffer_read(buf, buffer_text);
	
	// Separate headers from body
	var _req = string_split(_text, "\r\n\r\n");
	var _headers = string_split(_req[0], "\r\n");
	
	// HTTP method string & path
	var _method_string = string_split(array_shift(_headers), " ");
	
	var http_method = _method_string[0];
	var path = _method_string[1];
	var http_version = _method_string[2];
	
	var headers = array_map(_headers, function(h) {
		var split = string_split(h, ": ",, 1);
		return new Pair(split[0], split[1]);
	});
	
	return new Request(path, http_method, http_version, new Headers(headers));
}

/*
GET / undefined
Host: localhost:8080
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/112.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,\*\/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: cross-site
*/