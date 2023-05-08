/// @desc Strip double dots from a path to prevent directory traversal!
/// @param {string} dirty_path
function http_strip_double_dots(dirty_path){
	return string_strip_replace(dirty_path, "/..", "/");
}