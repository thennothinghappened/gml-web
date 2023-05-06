/// @desc Removes the duplicate slashes from the request path in a hacky way.
/// @param {string} path
function http_remove_duplicate_slashes(path) {
	while (string_count("//", path) > 0) {
		path = string_replace_all(path, "//", "/");
	}
	return path;
}