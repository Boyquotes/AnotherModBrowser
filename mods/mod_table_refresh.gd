extends TapButton
@onready var mod_table := $'../../Scroll/ModTable' as ModTable

func populate_mod_table():
	var mods := %Mods.get_mods() as Array[Mod]
	mod_table.populate(mods)
