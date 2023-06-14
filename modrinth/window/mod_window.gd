extends Window
var p: ModrinthProjectInfo
var s: ModrinthSearchResult

@export var InfoPanel: PanelContainer
@export var Versions: VBoxContainer
@export var Icon: TextureRect
@export var Title: Label
@export var Description: Label
@export var Author: Label
@export var LatestVersion: Label
@export var Downloads: RichTextLabel
@export var Body: RichTextLabel


func setup(_p: ModrinthProjectInfo, _s: ModrinthSearchResult):
	p = _p
	s =_s

	title = p.title
	InfoPanel.get('theme_override_styles/panel').bg_color = s.image_color_avg

	Icon.texture = s.icon_tex
	Title.text = p.title
	Description.text = p.description
	Author.text = s.author
	LatestVersion.text = s.latest_version
	Downloads.text = '[b]'+str(p.downloads)+'[/b] downloads'

	Body.format(p.body)

func decimal_to_color(v: int) -> Color:
	return Color8((v>>16)&0xff, (v >> 8) & 0xff, v&0xff, 255)
