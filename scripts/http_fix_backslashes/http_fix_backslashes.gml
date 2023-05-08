/// @desc Replaces backslashes with forward slashes for parsing pathes, also prevents inconsistencies between Windows and other OSes with static files.
/// @param {string} path
function http_fix_backslashes(path){
	return string_replace_all(path, "\\", "/");
}