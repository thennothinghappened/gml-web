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
		return "[" + get_datetime_readable() + "] [" + log_levels[level] + "] " + msg;
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
		
		return __info__("Server listening on port " + string(self.port));;
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
	/// @param {Id.DsMap} data_map
	function handle(data_map) {
		if (data_map[? "socket"] != self._server) {
			return;
		}
	}
	
	/// @desc Creates a new route and returns it for chaining methods
	/// @param {string} path
	/// @returns {Struct.Route}
	function route(path) {
		return self._router.route(path);
	}

	/// @param {function} middleware
	function use(middleware) {
		if (__check_running_complain__("add middleware")) { return false; }
		
		
	}
}