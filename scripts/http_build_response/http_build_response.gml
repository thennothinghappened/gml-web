/// @desc Build and return a HTTP response as a buffer
/// @param {string} http_version
/// @param {Enum.HTTP_CODE} http_status
/// @param {Struct.Headers} headers
/// @param {Id.Buffer|undefined} body
/// @returns {Id.Buffer}
function http_build_response(http_version, http_status, headers, body = undefined) {
	
	var headers_string = headers.toString();
	headers_string = $"{http_version} {http_status} {global._HTTP_CODES[http_status]}\r\n" + headers_string;
	
	if (body == undefined) {
		// our response has no body
		__debug__($"\"{headers_string}\"")
		var buf = buffer_create(string_byte_length(headers_string), buffer_fixed, 1);
		buffer_write(buf, buffer_text, headers_string);
		return buf;
	}
	
	// our response has a body
	headers_string += "\r\n";
	
	var buf = buffer_create(
		string_byte_length(headers_string) + buffer_get_size(body), buffer_fixed, 1
	);
	
	buffer_write(buf, buffer_text, headers_string);
	
	// copy the body buffer into the shared buffer of the headers + body right after the end of the headers.
	buffer_copy(body, 0, buffer_get_size(body), buf, string_byte_length(headers_string));
	
	return buf;
}