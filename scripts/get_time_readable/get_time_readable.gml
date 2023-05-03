/// @return {string}
function get_date_readable() {
	return string(current_year) + "-" + string(current_month) + "-" + string(current_day);
}

/// @return {string}
function get_time_readable() {
	return string(current_hour) + ":" + string(current_minute) + ":" +  string(current_second);
}

/// @return {string}
function get_datetime_readable() {
	return get_date_readable() + " " + get_time_readable();
}