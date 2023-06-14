extends RefCounted
class_name HTTPResult

@export var response_code: int
@export var headers: Dictionary
@export var body: Dictionary
var err_msg: String

func _init(_response_code := -1, _headers := {}, _body := {}, _err_msg = ''):
	response_code = _response_code
	headers = _headers
	body = _body
	err_msg = str(_err_msg)

static func err(msg = ''):
	var r := HTTPResult.new()
	r.err_msg = str(msg)
	return r

func is_valid() -> bool:
	return true if err_msg.is_empty() else false
