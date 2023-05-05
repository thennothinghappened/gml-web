function GMServer(debug = true) constructor {
	/// @ignore
	self._server = undefined;
	/// @ignore
	self._router = new Router("/");
	
	self.debug = debug;
	
	#region debug
	
	/// @ignore
	static log_levels = ["debug", "info", "error", "fatal"];

	/// @ignore
	/// @param {string} msg Message
	/// @param {real} level Log level (0 <-> 3)
	function __log_format__(msg, level) {
		return $"[{get_datetime_readable()}] [{log_levels[level]}] {msg}";
	}

	/// @ignore
	/// @param {string} msg Message
	/// @return {bool}
	function __debug__(msg) {
		show_debug_message(__log_format__(msg, 0));
		return true;
	}

	/// @ignore
	/// @param {string} msg Message
	/// @return {bool}
	function __info__(msg) {
		show_debug_message(__log_format__(msg, 1));
		return true;
	}
	
	/// @ignore
	/// @param {string} msg Message
	/// @return {bool}
	function __error__(msg) {
		show_debug_message(__log_format__(msg, 2));
		return false;
	}

	/// @ignore
	/// @param {string} msg Message
	function __fatal__(msg) {
		show_debug_message(__log_format__(msg, 3));
		throw "FATAL! " + msg;
	}
	
	/// @ignore
	/// @desc Complains if the server is running
	/// @param {string} complaint
	/// @param {bool} fatal
	/// @returns {bool}
	function __check_running_complain__(complaint, fatal = true) {
		if (self.__server__ != undefined) {
			var _complaint = "Tried to " + complaint + " on server while it was already running!";
		
			if (fatal) __fatal__(_complaint);
			return __error__(_complaint);
		}
		return false;
	}
	
	#endregion

	/// @desc Start the server. Should be run after any middleware has been added.
	/// @param {real} port
	/// @return {bool} Was successful
	function listen(port = 8080, max_clients = 10) {
		if (self._server != undefined) {
			return __error__("Tried to start a server when it was already running!");
		}
	
		__debug__("Starting server");
		self._server = network_create_server_raw(network_socket_tcp, port, max_clients);
		
		if (self._server < 0) {
			__fatal__("Failed to create the server!");
		}
		
		return __info__($"Server listening on port {port}");;
	}

	/// @desc Stop the server, cleans up the socket.
	function stop() {
		if (self._server != undefined) {
			__info__("Stopping server...");
			network_destroy(self._server);	
			self._server = undefined;
		}
		__info__("Server stopped.");
	}
	
	/// @desc Handle incoming packets in Async Networking event if they are ours
	/// @param {Id.Socket} socket
	/// @param {string} ip
	/// @param {Id.Buffer} data
	function handle(socket, ip, data) {
		try {
			var req = http_parse_request(data);
			var res = new Response();
			
			dispatch(req, res, method({ socket: socket }, function() {
				var body = "<html>hi!</html>";
				var str = $"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: {string_byte_length(body)}\r\n\r\n{body}";
				var buf = buffer_create(string_byte_length(str), buffer_fixed, 1);
				buffer_write(buf, buffer_text, str);
				
				network_send_raw(socket, buf, buffer_get_size(buf));
				buffer_delete(buf);
			}));
			
		} catch(e) {
			__error__(e.longMessage);
		}
		
		buffer_delete(data);
	}
	
	/// @desc Dispatch a request into the server
	/// @param {Struct.Request} req
	/// @param {Struct.Response} res
	/// @param {function} done
	function dispatch(req, res, done) {
		_router.dispatch(req, res, done);
	}
	
	/// @desc Creates a new route and returns it for chaining methods
	/// @param {string} path
	/// @returns {Struct.Route}
	function route(path) {
		return self._router.route(path);
	}

	/// @param {function} middleware
	//function use(middleware) {
//		if (__check_running_complain__("add middleware")) { return false; }
//		self._router.use(middleware);
//		
//	}
}