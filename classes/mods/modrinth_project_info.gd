extends RefCounted
class_name ModrinthProjectInfo

var id
var slug
var project_type
var title
var description
var body_url
var published
var updated
var approved
var queued
var status
var requested_status
var moderator_message
var license := {
	'id': '',
	'name': '',
	'url': '' }
var url
var client_side
var server_side
var downloads
var followers
var categories := []
var additional_categories := []
var game_versions := []
var loaders := []
var versions := []
var icon_url
var issues_url
var source_url
var wiki_url
var discord_url
var donation_urls := []
var gallery := []
var flame_anvil_project
var flame_anvil_user
var color
var team
var body

func _init(d := {}):
	for p in d.keys():
		if p in self:
			self[p] = d[p]
		else:
			push_warning(p)
