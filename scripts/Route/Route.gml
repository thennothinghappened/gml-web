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
	function _handles_method(_http_method) {
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
	function _options() {
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
	function dispatch(req, res, _done) {
		
		static stack_size;
		static index;
		static done;
		
		stack_size = array_length(self.stack);
		index = 0;
		done = _done;
		
		next(req, res);
		
		
		/// @param {Struct.Request} req
		/// @param {Struct.Response} res
		/// @param {Struct.Exception|undefined} err
		function next(req, res, err = undefined) {
			
			if (err != undefined) {
				return done(req, res, err);
			}
			
			
			var _layer = self.stack[index++];
			if (_layer == undefined) {
				return done(req, res, err);
			}
			
			if (_layer.http_method != undefined && _layer.http_method != req.http_method) {
				return next(req, res, err);
			}
			
			_layer.handle_request(req, res, next);
			
		}
	}
}