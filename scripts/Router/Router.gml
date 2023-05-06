/// @param {string} path
function Router(path) constructor {
	self.path = path;
	// The stack is an array of Layers which is run through.
	// Each layer gets a chance to run through its code, pass to the next, or stop execution.
	self.stack = [];
	
	/// @ignore
	/// @param {string} path
	static _options = function (path) {
		var stack_size = array_length(self.stack);
		var methods = [];
		
		for (i = 0; i < stack_size; i ++) {
			var _layer = self.stack[i];
			
			if (_layer.path != path) {
				continue;
			}
			
			if (_layer.http_method == undefined) {
				if (_layer.route != undefined) {
					methods = array_union(methods, _layer.route._options(path));
				}
				continue;
			}
			
			if (!array_contains(methods, _layer.http_method)) {
				array_push(methods, _layer.http_method);
			}
		}
		
		return methods;
	}
	
	/// @ignore
	/// @desc Handle the route if it belongs to us
	/// @param {Struct.Request} req
	/// @param {Struct.Response} res
	/// @param {Function} _done
	static dispatch = function (req, res, _done) {
		
		if (!string_starts_with(req.path, self.path)) {
			_done(req, res);
		}
		
		// Handle OPTIONS request
		if (req.http_method == "OPTIONS") {
			var options = _options(req.path);
			
			if (array_length(options) == 0) {
				return res
					.status(HTTP_CODE.NOT_FOUND)
					.finish();
			}
			
			return res
				.set(new Pair("Allow", array_join(", ", options)))
				.finish();
		}
		
		/// @param {Struct.Request} req
		/// @param {Struct.Response} res
		/// @param {Struct.Exception|undefined} err
		static next = function (req, res, err = undefined) {
			
			// Later allow custom error handler. For now we jump to the end.
			if (err != undefined) {
				return done(req, res, err);
			}
			
			var _layer;
			var _match = false;
			
			// find the next match
			while (!_match && index < stack_size) {
				_layer = stack[index++];
				_match = _layer.match(req.path, req.http_method);
				
				if (!_match) { 
					continue;
				}
				
			}
			
			if (!_match) {
				return done(req, res, err);
			}
			
			_layer.handle_request(req, res, method({
				stack_size: stack_size,
				stack: stack,
				next: next,
				index: index,
				done: done
			}, next));
			
		}
		
		var stack = self.stack;
		
		method({
			stack_size: array_length(stack),
			stack: stack,
			next: next,
			index: 0,
			done: _done
		}, next)(req, res);
	}
	
	/// @desc Creates a new routes and adds it to the stack
	/// @param {string} path
	/// @returns {Struct.Route}
	static route = function (path) {
		var _route = new Route(path);
		var _layer = new Layer(
			path, _route.dispatch, _route
		);
		
		array_push(self.stack, _layer);
		return _route;
	}
	
	/// @desc Add middleware(s) to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	/// @param {string|undefined} http_method
	static use = function (path = undefined, callback, http_method = undefined) {
		if (is_array(callback)) {
			array_foreach(callback, function(cb) { use(cb); });
		} else {
			array_push(self.stack, new Layer(path, callback, self, http_method));
		}
		return self;
	}
	
	/// @desc Add GET middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static get = function (path, callback) {
		use(path, callback, "GET");
		return self;
	}
	
	/// @desc Add HEAD middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static head = function (path, callback) {
		use(path, callback, "HEAD");
		return self;
	}
	
	/// @desc Add POST middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static post = function (path, callback) {
		use(path, callback, "POST");
		return self;
	}
	
	/// @desc Add PUT middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static put = function (path, callback) {
		use(path, callback, "PUT");
		return self;
	}
	
	/// @desc Add PATCH middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static patch = function (path, callback) {
		use(path, callback, "PATCH");
		return self;
	}
	
	/// @desc Add DELETE middleware to the router
	/// @param {string|undefined} path
	/// @param {function|array<function>} callback
	static delete_ = function (path, callback) {
		use(path, callback, "DELETE");
		return self;
	}
}