log_levels = ["info", "error", "fatal"];

/// @param {string} msg Message
/// @param {real} level Log level (0 <-> 2)
function __log_format__(msg, level) {
	return "[" + get_datetime_readable() + "] [" + log_levels[level] + "] " + msg;
}

/// @param {string} msg Message
/// @return {bool}
function __info__(msg) {
	show_debug_message(__log_format__(msg, 0));
	return true;
}

/// @param {string} msg Message
/// @return {bool}
function __error__(msg) {
	show_debug_message(__log_format__(msg, 1));
	return false;
}

/// @param {string} msg Message
function __fatal__(msg) {
	show_debug_message(__log_format__(msg, 2));
	throw "FATAL! " + msg;
}