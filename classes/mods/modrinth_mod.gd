extends RefCounted
class_name ModrinthMod

const placeholder_img := preload('res://modrinth/placeholder_image.tres')
const placeholder_tex := preload('res://modrinth/placeholder_texture.tres')
var icon_img := placeholder_img
var icon_tex := placeholder_tex

var request_search_result: Dictionary
var request_project_result: Dictionary
