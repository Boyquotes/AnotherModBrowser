extends RichTextLabel

func format(s: String):
	var output = []
	var platform := ('linux' if OS.get_name() in ["FreeBSD", "NetBSD", "OpenBSD", "BSD"] else OS.get_name().to_lower())
	var exit_code := OS.execute('./misc/bb/' + platform, [s], output)

	if exit_code:
		push_warning('exit code ', exit_code)

		text = '[font_size=18]Error converting to BBCode, try opening in your Browser instead.
Consider reporting this to me on Discord: Swarkin#0841' + ('

[b]Couldn\'t find executable.[/b]' if exit_code == 127 else '-') + '
Exited with Code ' + str(exit_code) + '
Output: ' + (str(output) if not output.is_empty() else 'None') + '

Displaying unformatted Content:[/font_size]\n\n' + str(s)
		return

	text = output[0]


func _on_meta_clicked(meta):
	OS.shell_open(meta)
