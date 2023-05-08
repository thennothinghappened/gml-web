/// @desc Decode HTTP-encoded characters
/// @param {string} str
function http_decode_characters(str) {
	var arr = string_array(str);
	for (var i = 0; i < array_length(arr); i ++) {
		if (arr[i] == "%") {
			// interpret next two as http-encoded
			if (i > array_length(arr) - 2) {
				break;
			}
			
			var _hex = arr[i+1] + arr[i+2];
			array_delete(arr, i+1, 2);
			
			var hex = real(string(ptr(_hex))); // https://www.youtube.com/watch?v=uYIw-4jD2gg
			arr[i] = chr(hex);
		}
	}
	
	return array_join("", arr);
}