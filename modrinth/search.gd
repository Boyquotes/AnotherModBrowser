extends LineEdit
const ModSearchPanel := preload('res://modrinth/mod_panel.tscn')

@export var HTTP: ModrinthSearch
@onready var progress := $RoundedCorners/SearchProgress as FakeProgressBar
@onready var WindowContent := $'../../Body/HFlow'


func _search_for(query := ''):
	HTTP.modrinth_search(query)
	var http_result = await HTTP.finished as HTTPResult
	if not http_result.is_valid():
		push_warning('Request failed: ', http_result.err_msg)
		return

	var results: Array[ModrinthSearchResult]

	for hit in http_result['body']['hits']:
		results.append(ModrinthSearchResult.new(hit))

	populate_search_list(results)


func populate_search_list(results: Array[ModrinthSearchResult]):
	clear_search_list()

	for r in results:
		var mod_panel := ModSearchPanel.instantiate()
		WindowContent.add_child(mod_panel)

		mod_panel.setup(r)

		if r.icon_url.is_empty():
			push_warning('No Icon URL')
			mod_panel.set_no_image()
			continue

		mod_panel.request_image(r.icon_url)

	HTTP.state = HTTP.State.Finished

func clear_search_list():
	for c in WindowContent.get_children():
		c.queue_free()
