extends Control
@onready var mod_table := %ModTable as ModTable

func _ready():
	populate_mod_table()


func populate_mod_table():
	var mods := %Mods.get_mods() as Array[Mod]
	mod_table.populate(mods)
