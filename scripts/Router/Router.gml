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
	static dispatch = function (req, res, _done) {
		
		/// @param {Struct.Request} req
		/// @param {Struct.Response} res
		/// @param {Struct.Exception|undefined} err
		static next = function (req, res, err = undefined) {
			
			// Later allow custom error handler. f\For now we jump to the end.
			if (err != undefined) {
				return done(err);
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
				return done(err);
			}
			
			_layer.handle_request(req, res, method({
				stack_size: stack_size,
				index: index,
				done: done
			}, next));
			
		}
		
		method({
			stack_size: array_length(self.stack),
			stack: self.stack,
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
	
	
	
	
	
}