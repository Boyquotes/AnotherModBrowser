extends ColorRect

func _ready():
	visible = true
	modulate = Color.BLACK

	if not OS.has_feature("editor"):
		for i in 3:
			await get_tree().process_frame

	create_tween().tween_property(self, 'modulate', Color.TRANSPARENT, 0.6) \
						.set_trans(Tween.TRANS_SINE) \
						.set_ease(Tween.EASE_OUT)
