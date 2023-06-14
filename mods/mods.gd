extends Node
const DummyMod := preload('res://mods/dummy_mod.tres')
var timing := Timing.new() #
var timing_files_loaded := Timing.new() #

func get_mods(checks := true) -> Array[Mod]:
	var p := Config.mod_path

	if checks:
		p = p.strip_edges()
		if p.is_empty():
			push_warning('No Mod path defined, check the Options')
			return [DummyMod]
		if '\\' in p and not p.ends_with('\\'):
			p += '\\'
			print('Added \\ to path')
		elif '/' in p and not p.ends_with('/'):
			p += '/'
			print('Added / to path')

		if not DirAccess.dir_exists_absolute(p):
			push_warning('Path is invalid: ', p)
			%Windows.show_window('Options')
			return [DummyMod]

		var d = DirAccess.get_files_at(p)
		var m = []
		for file in d:
			if file.ends_with('.jar') or file.ends_with('.disabled'):
				m.append(file)
		if len(m) == 0:
			push_warning('No mods found at ', p)
			$/root/Main/Windows.show_window('Options')
			return [DummyMod]

	var mods: Array[Mod]
	var names: Array = DirAccess.get_files_at(p)
	names.sort_custom(sort_case_insensitive)
	var metas: Array[Dictionary]

	# Metas
	timing_files_loaded.start() #
	var opened_files := 0 #
	var opened_zips  := 0 #

	for mod_name in names:
		var zip := ZIPReader.new()

		timing.start() #
		var err := zip.open(p + mod_name)
		if err:
			err = zip.open(p + mod_name + '.disabled')
			if err:
				print(p)
				push_warning('Mod not found | ', mod_name)
				metas.append({})
				continue

		opened_zips += 1 #

		for config_file in ['fabric.mod.json']: #, 'quilt.mod.json'
			if zip.file_exists(config_file):
				#print('file_exists          ', timing.check(), 'ms')
				opened_files += 1 #
				var reading_zip := zip.read_file(config_file)
				#print('zip.read_file        ', timing.check(), 'ms')
				var getting_string := reading_zip.get_string_from_utf8()
				#print('get_string_from_utf8 ', timing.check(), 'ms')
				var json_parse = JSON.parse_string(getting_string)
				#print('JSON.parse_string    ', timing.check(), 'ms')
				metas.append(json_parse)
				#print('metas.append         ', timing.check(), 'ms')
			else:
				#push_warning('Config not found | ', mod_name)
				metas.append({})

	print('Opening and reading ', opened_files, ' files, ', opened_zips, ' .jar archives took ', timing_files_loaded.check(), 'ms') #

	# Mods
	for i in len(names):
		var _name: String     = metas[i]['name']        if metas[i] else ''
		var _desc: String     = metas[i]['description'] if metas[i] else ''
		var _enabled: bool    = not names[i].ends_with('.disabled')
		var _path: String     = p
		var _filename: String = names[i]

		mods.append(Mod.new(_name, _desc, _enabled, _path, _filename))

	print('Constructing ModDatas ', timing.check(), 'ms') #

	Config.mod_cache = mods
	return mods


func sort_case_insensitive(a: String, b: String):
	if a.to_lower() < b.to_lower():
		return true
	return false
