extends VBoxContainer

@export var HTTP: ModrinthProjectVersions
@export var ModDownloadScene: PackedScene
@onready var p := owner.p as ModrinthProjectInfo
@onready var s := owner.s as ModrinthSearchResult


func _ready():
	if p:
		populate_version_list(await get_versions(p.slug))

func get_versions(_id_or_slug: String) -> Array[ModrinthProjectVersion]:
	HTTP.request_project_versions(_id_or_slug)
	var http_result = await HTTP.finished as HTTPResult
	if not http_result.is_valid():
		push_warning('Request failed: ', http_result.err_msg)
		return []

	var results: Array[ModrinthProjectVersion]

	for ver in http_result['body']['results']:
		results.append(ModrinthProjectVersion.new(ver))

	return results


func populate_version_list(versions: Array[ModrinthProjectVersion], show_latest := true):
	for v in versions:
		var scn := ModDownloadScene.instantiate()
		scn.p = p
		scn.v = v
		add_child(scn)
