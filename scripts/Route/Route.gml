/// @desc A singular route
/// @param {string} path
function Route(path) constructor {
	self.path = path;
	self.stack = [];
	self.methods = {};
	
	/// @ignore
	/// @desc Returns whether this route can handle a method
	/// @param {string} _http_method
	/// @returns {bool}
	static _handles_method = function (_http_method) {
		var http_method = string_upper(_http_method);
		
		return (
			self.methods[$ "_all"] ||
			(http_method == "HEAD" && variable_struct_exists(self.methods, "GET")) ||
			variable_struct_exists(self.methods, http_method)
		);
	}
	
	/// @ignore
	/// @desc Get list of methods
	/// @returns {array<string>}
	static _options = function () {
		var methods = struct_get_names(self.methods);
		
		if (array_contains(methods, "GET") && !array_contains(methods, "HEAD")) {
			array_push(methods, "HEAD");
		}
		
		return methods;
	}
	
	/// @desc Handle the route if its ours, run through the stack and finish.
	/// @param {Struct.Request} req
	/// @param {Struct.Response} res
	/// @param {Function} _done
	dispatch = function (req, res, _done) {
		
		/// @param {Struct.Request} req
		/// @param {Struct.Response} res
		/// @param {Struct.Exception|undefined} err
		static next = function (req, res, err = undefined) {
			
			if (err != undefined) {
				return done(req, res, err);
			}
			
			
			var _layer = stack[index++];
			if (_layer == undefined) {
				return done(req, res, err);
			}
			
			if (_layer.http_method != undefined && _layer.http_method != req.http_method) {
				return method({
					stack_size: stack_size,
					index: index,
					done: done
				}, next)(req, res, err);
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
	
	/// @desc Add middleware(s) to the route
	/// @param {function|array<function>} callback
	static use = function (callback) {
		if (is_array(callback)) {
			array_foreach(callback, function(cb) { use(cb); });
		} else {
			array_push(self.stack, new Layer(undefined, callback, self));
		}
		
	}
	
	/// @ignore
	/// @param {string} http_method
	/// @param {function} callback
	static _method = function (http_method, callback) {
		
		self.use(method(
			{ callback: callback, http_method: http_method },
			function (req, res, next) {
				
				if (req.http_method != http_method) {
					return next(req, res, next);
				}
			
				callback(req, res, next);
			
			})
		);
	}
	
	/// @desc Add a handler for a GET request
	/// @param {function|array<function>} callback
	static get = function (callback) {
		_method("GET", callback);
	}
}