
if (async_load[? "type"] != network_type_data) {
	return;
}

app.handle(async_load[? "id"], async_load[? "ip"], async_load[? "buffer"]);