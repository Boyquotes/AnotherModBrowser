extends VBoxContainer

@onready var main := $'../../../../Main' as ScrollContainer
@onready var content := $'../../../../Main/Content' as VBoxContainer


func scroll_to(node_name: String):
	var goal_node := main.get_node_or_null('Content/'+node_name)
	var scroll_amnt := 0

	if not goal_node:
		push_warning('node not found')
		return

	for node in content.get_children() as Array[Control]:
		if node.name == node_name:
			main.scroll_vertical = scroll_amnt
			return
		scroll_amnt += node.size.y + content.get_theme_constant('separation')
