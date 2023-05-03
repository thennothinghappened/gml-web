/// @param {real} _port
/// @param {bool} _debug
function create_server(_port = 8080, _debug = true){
	return instance_create_depth(0, 0, 0, oServer, {
		port: _port,
		debug: _debug
	});
}