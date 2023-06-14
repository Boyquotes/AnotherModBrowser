extends HTTPComponent
class_name ModrinthProjectVersions

func request_project_versions(id_or_slug: String):
	state = State.Active
	request(base_url+'project/'+id_or_slug+'/version', base_headers)

func _search_completed(err_code: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	if err_code:
		_finish_request(HTTPResult.err('Request failed with error '+str(err_code)))
		return
#	if not response_code in [200, 204]:
#		_finish_request(HTTPResult.err('HTTP '+str(response_code)))
#		return

	var headers := _headers_to_dict(_headers)
	var body := {'results': JSON.parse_string(_body.get_string_from_utf8()) as Array}

	if print_ratelimit:
		_ratelimit_from_headers(headers)

	_finish_request(HTTPResult.new(response_code, headers, body))

func _ready():
	request_completed.connect(_search_completed)
