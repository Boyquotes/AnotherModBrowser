extends Control
class_name ToggleWindow

@onready var opened := false
var previous_action := true # Open State
var active_tweens: Array

func _ready():
	visible = true
	toggle(Vector2.ZERO, false, true)

func toggle(from := Vector2.ZERO, force = null, skip_anim := false):
	if previous_action == force: return
	previous_action = force if force else opened

	pivot_offset = from

	for t in active_tweens: t.kill()
	active_tweens.clear()

	if force == true or opened: tween(Vector2.ZERO, Color.WHITE, 0.0 if skip_anim else 0.5)
	elif force == false or not opened: tween(Vector2(get_viewport().size.x, 0), Color.TRANSPARENT, 0.0 if skip_anim else 0.7)

	opened = not opened


func tween(_pos, _modulate, _time):
	var t := create_tween()
	t.tween_property(self, 'position', _pos, _time * 1.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tweens.append(t)

	t = create_tween()
	t.tween_property(self, 'modulate', _modulate, _time).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tweens.append(t)
