extends TapButton

func _pressed():
	OS.shell_open('https://modrinth.com/mod/'+owner.p.slug)
