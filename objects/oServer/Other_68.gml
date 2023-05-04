/// @desc Internal HTTP networking handler

// At the moment we'll ignore anything which isn't incoming data.
if (async_load[? "type"] != network_type_data) return;

// Create the request object

// Start the middleware stack
