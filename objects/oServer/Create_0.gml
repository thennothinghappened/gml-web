app = new GMServer();

counter = 0;

get_counter = function(req, res) {
	res.write($"<h1>{req.query[$ "counter_name"] ?? "Counter"}: {counter}</h1><br>");
	res.finish("<form method=\"POST\"><input type=\"submit\" value=\"Increment\"></form>");
}

increment_counter = function(req, res) {
	counter ++;
	get_counter(req, res);
}

app.get("/counter", get_counter);
app.post("/counter", increment_counter);
app.use(, app.static_content(, true));

function try_listening() {
	try {
		app.listen(8080);
	} catch (e) {
		app.stop();
		alarm[0] = game_get_speed(gamespeed_fps);
	}
}

try_listening();