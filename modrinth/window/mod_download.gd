extends HBoxContainer

var p: ModrinthProjectInfo
var v: ModrinthProjectVersion
@export var Version: Label
@export var Loader: Label
@export var Download: TapButton

func _ready():
	if not p or not v:
		push_warning('p or v null')
		return

	Version.text = str(v.game_versions)
	Loader.text = str(v.loaders)
	Download.pressed.connect(func(): OS.shell_open('https://modrinth.com/mod/'+p.slug))
