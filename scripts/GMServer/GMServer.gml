function GMServer(debug = true) constructor {
	/// @ignore
	self._server = undefined;
	/// @ignore
	self._router = new Router();
	
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
			var req, res;
			
			try {
				req = new Request(data, ip, self);
			} catch (err) {
				__error__(err);
				
				// Send back a HTTP 400 as the request was malformed.
				res = new Response(socket, "1.1", true);
				buffer_delete(data);
				
				return res
					.status(HTTP_CODE.BAD_REQUEST)
					.send("<h1>400 Bad Request<h1>");
			}
			
			res = new Response(socket, req.http_version, req.http_method != "HEAD" && req.http_method != "OPTIONS");
			
			__info__($"({ip}) {req.http_method} {req.path}");
			
			dispatch(req, res, method({ debug: debug }, function(req, res, err) {
				// Error handler
				if (err != undefined) {
					__error__(err.longMessage);
					
					return res
						.status(HTTP_CODE.INTERNAL_SERVER_ERROR)
						.finish($"<h1>500 Internal Server Error</h1>{debug ? $"GML Error: <pre>{err.longMessage}</pre>" : ""}");
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
	
	/// @desc Add HEAD middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static head = function (path, callback) {
		self._router.head(path, callback);
		return self;
	}
	
	/// @desc Add POST middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static post = function (path, callback) {
		self._router.post(path, callback);
		return self;
	}
	
	/// @desc Add PUT middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static put = function (path, callback) {
		self._router.put(path, callback);
		return self;
	}
	
	/// @desc Add PATCH middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static patch = function (path, callback) {
		self._router.patch(path, callback);
		return self;
	}
	
	/// @desc Add DELETE middleware to the app
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static delete_ = function (path, callback) {
		self._router.delete_(path, callback);
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
	
	/// @desc Serve static files from a directory. use() after other routes to avoid disk access when not required.
	/// @param {string} path Path that files will be served from
	/// @param {bool} dir_view Whether or not to use the directory viewer (you probably don't need it!)
	static static_content = function (path = "/web_root", dir_view = false) {
		return method({ serve_path: path, dir_view: dir_view }, function (req, res, next) {
			// We take next() in case of a miss.
			
			// Hacky way to prevent directory traversal... Mignt not be super reliable but above all else all reads
			// will still be contained to working_directory.
			var path = http_strip_double_dots(http_remove_duplicate_slashes(working_directory + serve_path + req.path));
			
			// Weird workaround stuff for how GM handles directories.
			var dir_exists = directory_exists(path);
			__debug__(path);
			// Serve index.html if it exists
			if (dir_exists && file_exists(path + "/index.html")) {
				path += "/index.html";
				dir_exists = false;
			}
			
			__debug__(path);
			
			// Serve a file
			if (file_exists(path) && !dir_exists) {
				var buf = buffer_load(path);
				
				// Set MIME type based on the extension...
				// Maybe later use magic bytes but that's more complex. (maybe outsource to "file")
				res.set_type(http_get_mimetype(filename_ext(path)));
				
				res.finish(buf);
				buffer_delete(buf);
				
				return;
			}
			
			// Serve the directory view if enabled
			if (dir_view && dir_exists) {
				var list = "";
				var fname = file_find_first(path + "/*", fa_none);
				
				while (fname != "") {
					// Later here we'll have file type exclusions and such
					list += $"<li><a href=\"./{fname}\">{fname}</a></li>";
					fname = file_find_next();
				}
				
				file_find_close();
				
				return res.send($"<!DOCTYPE html><html><head><title>Directory listing for {req.url}</title></head><body><h1>Directory listing for {req.url}</h1><hr><ul>{list}</ul></body></html>");
			}
			
			next(req, res);
		});
	}
}