function array_join(delimiter, array) {
	var str = "";
	var len = array_length(array);
	
	for (var i = 0; i < len; i ++) {
		str += array[i];
		if (i < len) {
			str += delimiter;
		}
	}
	
	return str;
}