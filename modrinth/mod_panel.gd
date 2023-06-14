extends Panel
const ModWindow := preload('res://modrinth/window/mod_window.tscn')
var search_result: ModrinthSearchResult

@export var HTTP: ModrinthProjectInformation
@export var progress: FakeProgressBar

@export var Title: Label
@export var Description: Label
@export var Icon: TextureRect
@export var Background: TextureRect
@export var NoImage: Label
@export var Author: Label
@export var Version: Label

func setup(r: ModrinthSearchResult):
	search_result = r
	Title.text = r.title
	if Title.text.length() > 25:
		Title.tooltip_text = r.title

	Description.text = r.description
	Author.text = r.author
	Version.text = r.latest_version


func _gui_input(event: InputEvent):
	if not HTTP.state == HTTP.State.Idle: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()
		open_popup()

func open_popup():
	HTTP.request_project_info(search_result.slug)
	var http_result := await HTTP.finished as HTTPResult
	if http_result.err_msg:
		push_warning(http_result.err_msg)
		return

	var window := ModWindow.instantiate()
	window.setup(ModrinthProjectInfo.new(http_result.body), search_result)
	add_child(window)


func request_image(img_url: String):
	if img_url.is_empty():
		push_warning('No Image provided for ', search_result.Title.text)
		set_no_image()
		return

	var http := HTTPRequest.new()
	http.request_completed.connect(_image_request_completed.bind(img_url))
	add_child(http)
	http.request(img_url)

func _image_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray, img_url: String):
	var err: int

	if img_url.ends_with('.png'):
		#print('Loading as .png: ', img_url, ' | ', Title.text)
		err = search_result.icon_img.load_png_from_buffer(body)
	elif img_url.ends_with('.webp'):
		#print('Loading as .webp: ', img_url, ' | ', Title.text)
		err = search_result.icon_img.load_webp_from_buffer(body)
	elif img_url.ends_with('.jpg') or img_url.ends_with('.jpeg'):
		#print('Loading as .jpg / .jpeg: ', img_url, ' | ', Title.text)
		err = search_result.icon_img.load_jpg_from_buffer(body)
	else:
		push_warning('Incompatible Image: ', img_url, ' | ', Title.text)
		set_no_image()
		return
	if err:
		push_warning(error_string(err), ': ', img_url)
		set_no_image()
		return

	# Icon
	search_result.icon_img.resize(128, 128, Image.INTERPOLATE_BILINEAR)
	search_result.icon_tex = ImageTexture.create_from_image(search_result.icon_img)
	Icon.texture = search_result.icon_tex

	# Background
	var gradient_tex := GradientTexture2D.new()
	var gradient := Gradient.new()
	var color := image_avg_color(search_result.icon_img)
	search_result.image_color_avg = color

	gradient.colors = [color*1.5 + Color.WHITE * 0.1, color*1.5 + Color.BLACK * 0.1]
	gradient_tex.gradient = gradient
	Background.texture = gradient_tex

func set_no_image():
	NoImage.visible = true
	Icon.get_parent().visible = false
	Background.get_parent().visible = false


func image_avg_color(img: Image) -> Color:
	var _w := img.get_width()
	var _h := img.get_height()
	if _w > 256 or _h > 256:
		push_warning('Computing average color may be slow on ', str(img.get_width()), 'x', str(img.get_height()), 'px Image')
	elif _w > 1024 or _h > 1024:
		push_warning('Ignoring', str(img.get_width()), 'x', str(img.get_height()), 'px Image as bounds are too big')
		return Color.BLACK

	#var t := Timing.new()
	#t.start()
	var pixels: PackedColorArray

	for x in _w:
		for y in _h:
			pixels.append(img.get_pixel(x,y))

	var _s := float(pixels.size())
	var _r := 0.0
	var _g := 0.0
	var _b := 0.0

	for c in pixels:
		_r += c.r
		_g += c.g
		_b += c.b

	#print('image_avg_color      ', t.check(), 'ms')
	return Color(_r/_s, _g/_s, _b/_s)
