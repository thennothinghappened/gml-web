

/// @desc An incoming HTTP request
/// @param {string} path
/// @param {string} http_method
/// @param {string} http_version
/// @param {string} ip
/// @param {Struct.Headers} headers HTTP headers
/// @param {Id.Buffer} body HTTP body
function Request(path, http_method, http_version, ip, headers, body = undefined) constructor {
	self.path = path;
	self.http_method = http_method;
	self.http_version = http_version;
	self.headers = headers;
	self.body = body;
}