/// @desc A singular route
/// @param {string} url
function Route(path) constructor {
	self.path = path;
	self.stack = [];
	self.methods = {};
	
	/// @desc Returns whether this route can handle a method
	/// @param {string} http_method
	/// @returns {bool}
	function handles_method(_http_method) {
		var http_method = string_upper(_http_method);
		
		return (
			self.methods[$ "_all"] ||
			(http_method == "HEAD" && variable_struct_exists(self.methods, "GET")) ||
			variable_struct_exists(self.methods, http_method)
		);
	}
	
	/// @desc Get list of methods
	/// @returns {array<string>}
	function _options() {
		var methods = variable_struct_get_names(self.methods);
		
		if (array_contains("GET") && !array_contains(methods, "HEAD")) {
			array_push(methods, "HEAD");
		}
		
		return methods;
	}
	
	/// @desc Handle the route if its ours, run through the stack and finish.
	/// @param {Id.Request} req
	/// @param {Id.Response} res
	/// @param {Function} next
	function handle(req, res, next) {
		
	}
}