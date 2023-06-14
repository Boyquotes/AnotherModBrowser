extends RefCounted
class_name ModrinthSearchResult

var slug
var title
var description
var categories
var client_side
var server_side
var project_type
var downloads
var icon_url
var color
var project_id
var author
var display_categories
var versions
var follows
var date_created
var date_modified
var latest_version
var license
var gallery
var featured_gallery

var image_color_avg: Color

# Used by mod_panel.gd
var icon_img := preload('res://modrinth/placeholder_image.tres')
var icon_tex := preload('res://modrinth/placeholder_texture.tres')


func _init(d := {}):
	for p in d.keys():
		if p in self:
			self[p] = d[p]
		else:
			push_warning(p)
