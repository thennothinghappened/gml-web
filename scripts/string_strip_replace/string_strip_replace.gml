/// @desc Strips out all occurances of substr and replaces with another.
/// @param {string} str
/// @param {string} substr
/// @param {string} newstr
/// @return {string}
function string_strip_replace(str, substr, newstr){
	while (string_count(substr, str) > 0) {
		str = string_replace_all(str, substr, newstr);
	}
	return str;
}