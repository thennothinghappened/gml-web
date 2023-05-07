/// @desc Gets the MIME type for a given input
/// @param {string|Struct|Id.Buffer} input Filetype string, Struct, Buffer
/// @return {string}
function http_get_mimetype(input) {
	static file_types = {
		"aac":	"audio/aac",
		"avif":	"image/avif",
		"avi":	"video/x-msvideo",
		"bin":	"application/octet-stream",
		"bmp":	"image/bmp",
		"bz":	"application/x-bzip",
		"bz2":	"application/x-bzip2",
		"css":	"text/css",
		"csv":	"text/csv",
		"doc":	"application/msword",
		"docx":	"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
		"gz":	"application/gzip",
		"gif":	"image/gif",
		"html": "text/html",
		"htm":	"text/html",
		"ico":	"image/vnd.microsoft.icon",
		"ics":	"text/calendar",
		"jar":	"application/java-archive",
		"jpeg":	"image/jpeg",
		"jpg":	"image/jpeg",
		"js":	"text/javascript",
		"json":	"application/json",
		"mjs":	"text/javascript",
		"mp3":	"audio/mpeg",
		"mp4":	"video/mp4",
		"mpeg":	"video/mpeg",
		"oga":	"audio/ogg",
		"ogg":	"application/ogg",
		"ogv":	"video/ogg",
		"ogx":	"application/ogg",
		"opus":	"audio/opus",
		"otf":	"font/otf",
		"png":	"image/png",
		"pdf":	"application/pdf",
		"php":	"application/x-httpd-php",
		"ppt":	"application/vnd.ms-powerpoint",
		"pptx":	"application/vnd.openxmlformats-officedocument.presentationml.presentation",
		"rar":	"application/vnd.rar",
		"rtf":	"application/rtf",
		"sh":	"application/x-sh",
		"svg":	"image/svg+xml",
		"tar":	"application/x-tar",
		"tiff":	"image/tiff",
		"ts":	"video/mp2t",
		"ttf":	"font/ttf",
		"txt":	"text/plain",
		"vsd":	"application/vnd.visio",
		"wav":	"audio/wav",
		"weba":	"audio/webm",
		"webm":	"video/webm",
		"webp":	"image/webp",
		"woff":	"font/woff",
		"woff2":"font/woff2",
		"xhtml":"application/xhtml+xml",
		"xls":	"application/vnd.ms-excel",
		"xlsx":	"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
		"xml":	"application/xml",
		"zip":	"application/zip"
	};
	
	if (is_string(input)) {
		var in = string_lower(input);
		
		// firstly if they just gave us a mime-type already...
		if (string_pos("/", in) != 0) {
			return in;
		}
		
		// file extension
		if (string_starts_with(in, ".")) {
			in = string_delete(in, 1, 1);
		}
		
		return file_types[$ in] ?? file_types[$ "bin"];
	}
	
	// json
	if (is_struct(input)) {
		return file_types[$ "json"];
	}
	
	// probably a buffer, or we don't know anyway.
	return file_types[$ "bin"];
}