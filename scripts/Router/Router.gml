/// @param {string} path
function Router(path) constructor {
	self.path = path;
	// The stack is an array of Layers which is run through.
	// Each layer gets a chance to run through its code, pass to the next, or stop execution.
	self.stack = [];
	
	/// @desc Handle the route if it belongs to us
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
			
			// Later allow custom error handler. f\For now we jump to the end.
			if (err != undefined) {
				return done(err);
			}
			
			var _layer;
			var _match = false;
			
			// find the next match
			while (!_match && index < stack_size) {
				_layer = self.stack[index++];
				_match = _layer.match(req.url, req.http_method);
				
				if (!_match) { 
					continue;
				}
				
			}
			
			if (!_match) {
				return done(err);
			}
			
			_layer.handle_request(req, res, next);
			
		}
	}
	
	/// @desc Creates a new routes and adds it to the stack
	/// @param {string} path
	/// @returns {Struct.Route}
	function route(path) {
		var _route = new Route(path);
		var _layer = new Layer(
			path, _route.handle, _route
		);
		
		array_push(self.stack, _layer);
		return _route;
	}
	
	
	
	
	
}