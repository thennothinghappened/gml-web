/// @param {string|undefined} path
/// @param {function} func
/// @param {Id.Instance<Route>|undefined} route
/// @param {string|undefined} http_method
function Layer(path, func, route = undefined, http_method = undefined) constructor {
	self.path = path;
	self.handle = func;
	self.route = route;
	self.http_method = http_method;
	
	/// @desc Match if the path & method is ours
	/// @param {string} path
	/// @param {string} http_method
	static match = function (path, http_method) {
		return (
			self.path == undefined ||
			path == self.path ||
			string_starts_with(path, self.path + "/")
		) && match_method(http_method);
	}
	
	/// @desc Match if the method is ours
	/// @param {string} http_method
	static match_method = function (http_method) {
		return (
			self.http_method == undefined ||
			self.http_method == http_method ||
			(self.http_method == "GET" && http_method == "HEAD") // app.head needs to always be before app.get if custom HEAD or this will steal it!
		);
	}
	
	/// @desc Handle a request for the route
	/// @param {Struct.Request} req
	/// @param {Struct.Response} res
	/// @param {function} next
	static handle_request = function (req, res, next) {
		try {
			handle(req, res, next);
		} catch(err) {
			next(req, res, err);
		}
	}
}