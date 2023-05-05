/// @param {string|undefined} path
/// @param {function} func
/// @param {Struct.Route|undefined} route
/// @param {string|undefined} http_method
function Layer(path, func, route = undefined, http_method = undefined) constructor {
	self.path = path;
	self.handle = func;
	self.route = route;
	self.http_method = http_method;
	
	/// @desc Match if the path is ours
	/// @param {string} path
	/// @param {string} http_method
	function match(path, http_method) {
		return (path == self.path || self.path == undefined) && (self.http_method == undefined || self.http_method == http_method);
	}
	
	/// @desc Handle a request for the route
	/// @param {Struct.Request} req
	/// @param {Struct.Response} res
	/// @param {function} next
	function handle_request(req, res, next) {
		try {
			self.handle(req, res, next);
		} catch(err) {
			next(req, res, err);
		}
	}
}