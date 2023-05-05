/// @ignore
global._server_log_levels = ["debug", "info", "error", "fatal"];
#macro log_levels global._server_log_levels

/// @ignore
/// @param {string} msg Message
/// @param {real} level Log level (0 <-> 3)
function __log_format__(msg, level) {
	return $"[{get_datetime_readable()}] [{log_levels[level]}] {msg}";
}

/// @ignore
/// @param {string} msg Message
/// @return {bool}
function __debug__(msg) {
	show_debug_message(__log_format__(msg, 0));
	return true;
}

/// @ignore
/// @param {string} msg Message
/// @return {bool}
function __info__(msg) {
	show_debug_message(__log_format__(msg, 1));
	return true;
}
	
/// @ignore
/// @param {string} msg Message
/// @return {bool}
function __error__(msg) {
	show_debug_message(__log_format__(msg, 2));
	return false;
}

/// @ignore
/// @param {string} msg Message
function __fatal__(msg) {
	show_debug_message(__log_format__(msg, 3));
	throw "FATAL! " + msg;
}