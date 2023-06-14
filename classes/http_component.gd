extends HTTPRequest
class_name HTTPComponent
signal finished(result: HTTPResult)

const base_url := 'https://api.modrinth.com/v2/'
const base_headers := [
	'User-Agent: swarkin/AnotherModBrowser (Swarkin#0841)',
	'Never-Gonna: Give-You-Up' ]

enum State {Idle, Active, Finished, Failed}
var state := State.Idle

@export var print_ratelimit := true


func _finish_request(result: HTTPResult):
	state = State.Finished if result.is_valid() else State.Failed
	finished.emit(result)

func _headers_to_dict(arr: PackedStringArray) -> Dictionary:
	var dict := {}

	for v in arr:
		var a := v.split(': ')
		dict[a[0]] = a[1]
		#print(a[0], ' | ', a[1])

	return dict

func _ratelimit_from_headers(h: Dictionary):
	print(h['X-Ratelimit-Remaining'], '/', h['X-Ratelimit-Limit'], ' | ', h['X-Ratelimit-Reset'], 's')
