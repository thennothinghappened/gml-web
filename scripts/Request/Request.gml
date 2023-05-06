

/// @desc An incoming HTTP request
/// @param {Struct.GMServer} app
/// @param {string} path
/// @param {string} http_method
/// @param {string} http_version
/// @param {string} ip
/// @param {Struct.Headers} headers HTTP headers
/// @param {string} body HTTP body
function Request(app, path, http_method, http_version, ip, headers, body = undefined) constructor {
	self.app = app;
	self.path = path;
	self.http_method = http_method;
	self.http_version = http_version;
	self.headers = headers;
	self.ip = ip;
	/// @ignore
	self._body = body;
	self.body = {};
	
	static type = function () {
		return self.headers.type();
	}
}