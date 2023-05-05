# gml-web
 Complete rewrite of my much earlier project, the equally uncreatively named [gamemaker-http-server](https://github.com/thennothinghappened/gamemaker-http-server). Modelled *heavily* after ExpressJS - though in a much worse and less secure form. Should go without saying not to try and use this for something important, but it's still cool, right.....???

## Quickstart
 The server needs one object to function, this is just so it can piggyback off the Async Network event. \
 **Create Event**:
 ```gml
 server = new GMServer();

 // middleware (blank 1st argument is global middleware)
 server.get(, function(req, res, next) {
    if (req.type() == "text/html") {
        res.send($"your IP is <b>{req.ip}</b> <br>");
    }
    next(req, res);
 });
 
 // use the JSON parser:
 server.use(, server.json());

 // init a route
 server.get("/hello", function(req, res) {
    res.finish("<h1>Hello!</h1>");
 });

 // POST route
 server.post("/do_thing", function(req, res) {
    res.json({"answer": req.body.number * 2});
 })
 ```
 **Async - Networking Event**:
 ```gml
 if (async_load[? "type"] != network_type_data) {
 	return;
 }

 server.handle(async_load[? "id"], async_load[? "ip"], async_load[? "buffer"]);
 ```
 Make sure your object is also **persistent**.