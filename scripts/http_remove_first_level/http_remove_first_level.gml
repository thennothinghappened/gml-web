/// @desc Removes the first level of a HTTP request path or returns empty string if none remaining
/// @param {string} _path
/// @return {string}
function http_remove_first_level(_path){
	var path = string_trim_start(_path, ["/"]);
	var level_split = string_split(path, "/",, 1);
	
	if (array_length(level_split) != 2) {
		return "/" + level_split[0];
	}
	
	return "/" + level_split[1];
}