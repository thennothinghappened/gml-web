/// @param {Id.Socket} socket
/// @param {string} http_version
/// @param {bool} send_body
function Response(socket, http_version, send_body = true) constructor {
	/// @ignore
	self.socket = socket;
	/// @ignore
	self.headers = new Headers();
	/// @ignore
	self.body = buffer_create(1, buffer_grow, 1);
	/// @ignore
	self.http_status = HTTP_CODE.OK;
	/// @ignore
	self.http_version = http_version;
	/// @ignore
	self.send_body = send_body;
	
	/// @desc Get a HTTP header by its name
	/// @param {string} header
	/// @return {string|undefined}
	static get = function (header) {
		return self.headers.get(header);
	}
	
	/// @desc Set a HTTP header
	/// @param {Struct.Header} header
	static set = function (header) {
		self.headers.set(header);
		return self;
	}
	
	/// @desc Set the MIME type of the file
	/// @param {string} type
	static set_type = function (mime_type) {
		self.headers._set_content_type(http_get_mimetype(mime_type));
		return self;
	}
	
	/// @desc Get the MIME type
	static get_type = function () {
		return self.headers.type();
	}
	
	/// @desc Set HTTP status for the response
	/// @param {Enum.HTTP_CODE} http_status
	static status = function (http_status) {
		self.http_status = http_status;
		return self;
	}
	
	/// @desc Append data to the body
	/// @param {string|Id.Buffer} data
	static write = function (data) {
		// Append as string
		if (is_string(data)) {
			buffer_write(self.body, buffer_text, data);
			return self;
		}
		
		// Append as buffer
		if (buffer_exists(data)) {
			buffer_copy(data, 0, buffer_get_size(data), self.body, buffer_get_size(self.body) + 1);
			return self;
		}
		
		// Unsupported data!
		__fatal__($"Tried to write unsupported data type {typeof(data)}");
	}
	
	/// @desc Send the request with data, auto-setting the MIME type based on the data.
	/// @param {string|Id.Buffer|Struct} data
	static send = function (data) {
		if (is_struct(data)) {
			return json(data);
		}
		
		var type = "text/html";
		
		if (!is_string(data)) {
			type = "application/octet-stream";
		}
		
		if (get_type() == undefined) {
			set_type(type);
		}
		
		finish(data);
	}
	
	/// @desc Finish the request and optionally append some data.
	/// @param {string|Id.Buffer|undefined} data
	static finish = function (data) {
		if (data != undefined) {
			write(data);
		}
		
		// Remove the excess buffer size we've accumulated in writes
		buffer_resize(self.body, buffer_tell(self.body));
		self.headers._set_content_length(self.body);
		
		var buf = http_build_response(self.http_version, self.http_status, self.headers, (self.send_body ? self.body : undefined));
		network_send_raw(self.socket, buf, buffer_get_size(buf));
		
		buffer_delete(buf);
		
		// We don't need the body anymore since the request was sent
		buffer_delete(self.body);
		self.body = undefined;
		
	}
	
	/// @desc Finish the request with JSON data.
	/// @param {Struct} data
	static json = function (data) {
		if (get_type() == undefined) {
			set_type("application/json");
		}
		finish(json_stringify(data));
	}
}