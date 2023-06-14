extends ProgressBar
class_name FakeProgressBar
@export var HTTP: HTTPComponent

@export var free_after_success := false
var free_queued := false

func _init():
	show_percentage = false
	max_value = 1
	step = 0

func _fade_out():
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	t.tween_property(self, 'modulate', Color.TRANSPARENT, 0.8).finished.connect(func():
		value = 0
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART) \
		.tween_property(self, 'modulate', Color.WHITE, 0.8).finished.connect(func():
			if free_after_success and free_queued: queue_free()
		)
	)

func _process(dt):
	if not HTTP: return

	match HTTP.state:
		HTTP.State.Active:
			value = lerp(value, 0.9, 0.95 * dt)

		HTTP.State.Finished:
			value = lerp(value, 1.0, 9.5 * dt)
			if not value >= 0.99: return

			HTTP.state = HTTP.State.Idle
			if free_after_success: free_queued = true
			_fade_out()

		HTTP.State.Failed:
			value = lerp(value, 0.0, 9.5 * dt)
			if not value <= 0.01: return

			HTTP.state = HTTP.State.Idle
			_fade_out()
