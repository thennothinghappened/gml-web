
// disable window rendering
application_surface_draw_enable(false);
draw_enable_drawevent(false);

server = new GMServer();

server.use(server.json());

server.use("/test", function(req, res, next) {
	res.send("WHAT");
	next(req, res);
});

server.route("/test")
	.get(function(req, res) {
		res.finish("<h1>MWUHAHAHAHA</h1>");
	})
	.post(function (req, res) {
		res.json(req.body);
	});


function try_listening() {
	try {
		server.listen(8080);
	} catch (e) { server.stop(); alarm[0] = game_get_speed(gamespeed_fps); }
}

try_listening();