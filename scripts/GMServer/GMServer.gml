function GMServer(debug = true) constructor {
	/// @ignore
	self._server = undefined;
	/// @ignore
	self._router = new Router("/");
	
	self.debug = debug;
	
	#region debug
	
	/// @ignore
	/// @desc Complains if the server is running
	/// @param {string} complaint
	/// @param {bool} fatal
	/// @returns {bool}
	static __check_running_complain__ = function (complaint, fatal = true) {
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
	static listen = function (port = 8080, max_clients = 10) {
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
	static stop = function () {
		if (self._server != undefined) {
			__info__("Stopping server...");
			network_destroy(self._server);	
			self._server = undefined;
		}
		__info__("Server stopped.");
	}
	
	/// @desc Gets whether the server is currently listening
	static listening = function () {
		return self._server != undefined;
	}
	
	/// @desc Handle incoming packets in Async Networking event if they are ours
	/// @param {Id.Socket} socket
	/// @param {string} ip
	/// @param {Id.Buffer} data
	static handle = function (socket, ip, data) {
		try {
			var req = http_parse_request(data, ip);
			var res = new Response(socket, req.http_version, req.http_method != "HEAD" && req.http_method != "OPTIONS");
			
			__info__($"({ip}) {req.http_method} {req.path}");
			
			dispatch(req, res, method({ debug: debug }, function(req, res, err) {
				// Error handler
				if (err != undefined) {
					return res
						.status(HTTP_CODE.INTERNAL_SERVER_ERROR)
						.finish($"<h1>500: Internal Server Error</h1>{debug ? $"GML Error: {err.longMessage}" : ""}");
				}
				
				// Our 404 handler. If we made our way here, then we mustn't have hit any actual pages.
				return res
					.status(HTTP_CODE.NOT_FOUND)
					.finish("<h1>404: Not Found</h1>");
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
	static dispatch = function (req, res, done) {
		_router.dispatch(req, res, done);
	}
	
	/// @desc Creates a new route and returns it for chaining methods
	/// @param {string} path
	/// @returns {Struct.Route}
	static route = function (path) {
		return self._router.route(path);
	}

	/// @desc Add middleware(s) to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static use = function (path = undefined, callback) {
		self._router.use(path, callback);
		return self;
	}
	
	/// @desc Add GET middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static get = function (path, callback) {
		self._router.get(path, callback);
		return self;
	}
	
	/// @desc Add POST middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static post = function (path, callback) {
		self._router.post(path, callback);
		return self;
	}
	
	/// @desc JSON body parser, app.use this to support JSON parsing
	static json = function () {
		return function (req, res, next) {
			if (req._body != undefined) {
				if (string_starts_with(req.type(), "application/json")) {
					req.body = json_parse(req._body);
				}
			}
			
			next(req, res);
		}
	}
}