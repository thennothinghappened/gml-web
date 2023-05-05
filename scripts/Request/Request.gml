

/// @desc An incoming HTTP request
/// @param {string} url
/// @param {string} http_method
/// @param {Struct.Headers} headers HTTP headers
/// @param {Id.Buffer} body HTTP body
function Request(url, http_method, headers, body = undefined) constructor {
	self.url = url;
	self.http_method = http_method;
	self.headers = headers;
	self.body = body;
}