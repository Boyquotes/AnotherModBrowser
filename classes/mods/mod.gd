extends Resource
class_name Mod

var title: String
var description: String
var author: String
var loader: String

var enabled: bool
var version: String
var path: String
var filename: String

func _init(	_title := '', _description := '', _enabled := false,
				_path := '', _filename := '',
				_author := '', _version := '' ):

	title = _title
	description = _description
	enabled = _enabled

	path = _path
	filename = _filename

	author = _author
	version = _version


func set_enabled(enable: bool):
	var old_file := filename
	var new_file := filename
	var suffix := '.disabled'

	print('Old: ', old_file)

	if enable and old_file.ends_with(suffix):
		print('Enabling')
		new_file = old_file.trim_suffix(suffix)
	elif not old_file.ends_with(suffix):
		print('Disabling')
		new_file = old_file + suffix

	print('New: ', new_file)

	var err := DirAccess.open(path).rename(old_file, new_file)
	if err: push_warning(error_string(err))

	filename = new_file

func delete() -> bool:
	print(title, ' deletion requested')
	var success = true
	return success
