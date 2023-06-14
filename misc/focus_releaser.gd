extends Control
class_name FocusReleaser

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent):
	if not event is InputEventMouseButton: return
	if not event.pressed: return

	var parent := get_parent() as Control
	if not parent.has_focus(): return

	var control_rect := parent.get_rect()
	control_rect.position = Vector2.ZERO

	if control_rect.has_point(parent.get_local_mouse_position()): return
	parent.release_focus()
	get_viewport().set_input_as_handled()
