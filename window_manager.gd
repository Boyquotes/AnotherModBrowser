extends Control

@onready var windows := get_children()
var dict = {
	'key': 'value'
}

func show_window(w_name: String, from_pos := Vector2.ZERO):
	if from_pos.is_zero_approx():
		# Find pos from button
		#var button := %Buttons.get_node('VBox').get_node_or_null(w_name)
		#if button:
		#	from_pos = button.position
		#else:
			# Middle of viewport
		from_pos = get_viewport().size
		from_pos.y /= 2

	for w in windows:
		if w.name == w_name:
			w.toggle(from_pos)
		else:
			w.toggle(from_pos, false)
