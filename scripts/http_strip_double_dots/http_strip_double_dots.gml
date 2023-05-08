/// @desc Strip double dots from a path to prevent directory traversal!
/// @param {string} dirty_path
function http_strip_double_dots(dirty_path){
	while (string_count("/..", dirty_path) > 0) {
		dirty_path = string_replace_all(dirty_path, "/..", "/");
	}
	return dirty_path;
}