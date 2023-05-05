
// disable window rendering
application_surface_draw_enable(false);
draw_enable_drawevent(false);

server = new GMServer();

server.route("/test")
	.get(function (req, res) {
		show_debug_message(req.url);
	});

function try_listening() {
	try {
		server.listen(8080);
	} catch (e) { server.stop(); alarm[0] = game_get_speed(gamespeed_fps); }
}

try_listening();