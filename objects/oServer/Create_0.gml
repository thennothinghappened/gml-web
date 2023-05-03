self.__server__ = undefined;
self.__middleware__ = [];

/// @desc Start the server. Should be run after any middleware has been added.
/// @return {bool} Was successful
function start() {
	if (self.__server__ != undefined) {
		return __error__("Tried to start a server when it was already running!");
	}
	
	self.__server__ = network_create_server(network_socket_tcp, self.port, 50);
	return true;
}

/// @desc Stop the server, cleans up the socket.
function stop() {
	if (self.__server__ != undefined) {
		network_destroy(self.__server__);	
	}
}

/// @desc Complains if the server is running
/// @param {string} complaint
/// @param {bool} fatal
/// @returns {bool}
function __check_running_complain__(complaint, fatal = true) {
	if (self.__server__ != undefined) {
		var _complaint = "Tried to " + complaint + " on server while it was already running!";
		
		if (fatal) __fatal__(_complaint);
		return __error__(_complaint);
	}
	return false;
}

/// @param {real} _port New port
/// @returns {bool}
function set_port(_port) {
	if (__check_running_complain__("set port")) { return false; }
	
	self.port = _port;
	return true;
}

/// @param {function} middleware
function add(middleware) {
	if (__check_running_complain__("add middleware")) { return false; }
	
	array_push(self.__middleware__, middleware);
}