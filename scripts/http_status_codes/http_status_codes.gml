enum HTTP_CODE {
	// 2XX
	OK = 200,
	CREATED = 201,
	ACCEPTED = 202,
	NON_AUTHORITATIVE_INFORMATION = 203,
	NO_CONTENT = 204,
	RESET_CONTENT = 205,
	PARTIAL_CONTENT = 206,
	
	// 3XX
	MULTIPLE_CHOICES = 300,
	MOVED_PERMANENTLY = 301,
	FOUND = 302,
	SEE_OTHER = 303,
	NOT_MODIFIED = 304,
	
	TEMPORARY_REDIRECT = 307,
	PERMANENT_REDIRECT = 308,
	
	// 4XX
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	
	FORBIDDEN = 403,
	NOT_FOUND = 404,
	METHOD_NOT_ALLOWED = 405,
	NOT_ACCEPTABLE = 406,
	
	CONFLICT = 409,
	GONE = 410,
	LENGTH_REQUIRED = 411,
	PRECONDITION_FAILED = 412,
	PAYLOAD_TOO_LARGE = 413,
	URI_TOO_LONG = 414,
	UNSUPPORTED_MEDIA_TYPE = 415,
	RANGE_NOT_SATISFIABLE = 416,
	EXPECTATION_FAILED = 417,
	
	UPGRADE_REQUIRED = 426,
	
	PRECONDITION_REQUIRED = 428,
	TOO_MANY_REQUESTS = 429,
	
	REQUEST_HEADER_FIELD_TOO_LARGE = 431,
	
	// 5XX
	INTERNAL_SERVER_ERROR = 500,
	NOT_IMPLEMENTED = 501,
	BAD_GATEWAY = 502,
	SERVICE_UNAVAILABLE = 503,
	GATEWAY_TIMEOUT = 504,
	HTTP_VERSION_NOT_SUPPORTED = 505
}

var http_codes = {
	// 2XX
	"OK": 200,
	"Created": 201,
	"Accepted": 202,
	"Non-Authoritative Information": 203,
	"No Content": 204,
	"Reset Content": 205,
	"Partial Content": 206,
	
	// 3XX
	"Multiple Choices": 300,
	"Moved Permanently": 301,
	"Found": 302,
	"See Other": 303,
	"Not Modified": 304,
	
	"Temporary Redirect": 307,
	"Permanent Redirect": 308,
	
	// 4XX
	"Bad Request": 400,
	"Unauthorized": 401,
	
	"Forbidden": 403,
	"Not Found": 404,
	"Method Not Allowed": 405,
	"Not Acceptable": 406,
	
	"Conflict": 409,
	"Gone": 410,
	"Length Required": 411,
	"Precondition Failed": 412,
	"Payload Too Large": 413,
	"URI Too Long": 414,
	"Unsupported Media Type": 415,
	"Range Not Satisfiable": 416,
	"Expectation Failed": 417,
	
	"Upgrade Required": 426,
	
	"Precondition Required": 428,
	"Too Many Requests": 429,
	
	"Request Header Field Too Large": 431,
	
	// 5XX
	"Internal Server Error": 500,
	"Not Implemented": 501,
	"Bad Gateway": 502,
	"Service Unavailable": 503,
	"Gateway Timeout": 504,
	"HTTP Version Not Supported": 505
}

/// @ignore
global._HTTP_CODES = [];
struct_foreach(http_codes, function(name, code) {
	global._HTTP_CODES[code] = name;
});