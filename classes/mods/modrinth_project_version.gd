extends RefCounted
class_name ModrinthProjectVersion

var name := ''
var version_number := ''
var changelog := ''
var dependencies := [{
	'version_id': '',
	'project_id': '',
	'file_name': '',
	'dependency_type': '' }]
var game_versions := []
var version_type := ''
var loaders := []
var featured := false
var status := ''
var requested_status := ''
var id := ''
var project_id := ''
var author_id := ''
var date_published := ''
var downloads := 0
var changelog_url := ''
var files := [{
	'hashes': {
		'sha512': '',
		'a1': '' },
	'url': '',
	'filename': '',
	'primary': false,
	'size': 0,
	'file_type': '' }]

func _init(d := {}):
	for p in d.keys():
		if p in self:
			self[p] = d[p] if not d[p] == null else ''
		else:
			push_warning(p, ' is ', d[p])
