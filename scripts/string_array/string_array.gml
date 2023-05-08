/// @desc Convert a string to an array
/// @param {string} str
/// @return {array<string>}
function string_array(str) {
	var arr = [];
	var len = string_length(str);
	for (var i = 1; i <= len; i ++) {
		arr[i-1] = string_char_at(str, i);
	}
	
	return arr;
}