extends Button
class_name TapButton
const TapScene := preload('res://misc/tap/tap.tscn')

@export var tap_parent: Control = self
@export var scale_mult := 1.0
@export var speed_mult := 1.0


func _ready():
	if not tap_parent == self: return

	tap_parent = Control.new()
	tap_parent.mouse_filter = MOUSE_FILTER_IGNORE
	tap_parent.clip_contents = true
	tap_parent.set_anchors_preset(PRESET_FULL_RECT)
	add_child(tap_parent)


func tap():
	var _tap := TapScene.instantiate()
	tap_parent.add_child(_tap)
	_tap.position = get_local_mouse_position() - _tap.pivot_offset

	var t := _tap.create_tween()
	t.finished.connect(func(): _tap.queue_free())
	t.tween_property(_tap, 'scale', Vector2.ONE * scale_mult, 0.7 * speed_mult).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	t = _tap.create_tween()
	t.tween_property(_tap, 'modulate', Color.TRANSPARENT, 0.7 * speed_mult).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func _pressed():
	tap()
