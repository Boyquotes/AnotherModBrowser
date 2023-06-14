extends VBoxContainer
class_name ModTable
enum Style {Regular, Header}
const Row := preload('res://mods/mod_row.tscn')


var row_index := 0

func populate(mods: Array[Mod], append := false):
	if not append:
		_clear()
		row_index = 0

	var timing := Timing.new() #
	timing.start() #

	for mod in mods:
		var row := Row.instantiate()
		row.name = 'ModRow'+str(row_index)#.pad_zeros(3)
		if not row.name == 'ModRow'+str(row_index):
			push_warning('A ModRow is named incorrectly. You shouldnt get this message, I hope. ', row.name)

		row.get_node('Name').text = mod.title
		row.get_node('Description').text = mod.description
		row.get_node('Filename').text = mod.filename
		row.get_node('State').button_pressed = mod.enabled

		# Signals
		row.get_node('State').toggled.connect(set_enabled.bind(row_index))
		row.get_node('Delete').pressed.connect(delete.bind(row_index))

		add_child(row)
		row_index += 1

	print('Creating Table with ', row_index, ' rows took ', timing.check(), 'ms') #


func _clear():
	for node in get_children():
		if not node.name == 'HeaderRow':
			remove_child(node)
			node.queue_free()


func set_enabled(state: bool, i: int):
	var mods: Array[Mod] = Config.mod_cache
	var mod := mods[i]
	mod.set_enabled(state)

func delete(i: int):
	var mods: Array[Mod] = Config.mod_cache
	var mod := mods[i]

	if mod.delete():
		get_node('ModRow'+str(i)).queue_free()
