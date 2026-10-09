extends Node
## The player's progress: skill points, unlocked upgrades per device and
## finished missions. Saved to a JSON file.

const TREE_PATHS := {
	"badge": "res://data/upgrades/badge.tres",
	"weapon": "res://data/upgrades/weapon.tres",
	"drone": "res://data/upgrades/drone.tres",
	"vehicle": "res://data/upgrades/vehicle.tres",
}

var save_path := "user://save.json"
var skill_points := 0
## device id -> Array of unlocked upgrade ids
var unlocked := {}
var completed_missions: Array[String] = []
## device id -> UpgradeTree
var trees := {}


func _ready() -> void:
	for device in TREE_PATHS:
		trees[device] = load(TREE_PATHS[device])
	reset()
	load_game()


func reset() -> void:
	skill_points = 0
	completed_missions.clear()
	unlocked.clear()
	for device in trees:
		unlocked[device] = []


func has_upgrade(device: String, upgrade_id: String) -> bool:
	return unlocked.get(device, []).has(upgrade_id)


func can_unlock(device: String, upgrade_id: String) -> bool:
	var tree: UpgradeTree = trees.get(device)
	if tree == null:
		return false
	var node := tree.find(upgrade_id)
	if node == null or has_upgrade(device, upgrade_id) or skill_points < node.cost:
		return false
	for required in node.requires:
		if not has_upgrade(device, required):
			return false
	return true


func unlock(device: String, upgrade_id: String) -> bool:
	if not can_unlock(device, upgrade_id):
		return false
	skill_points -= trees[device].find(upgrade_id).cost
	unlocked[device].append(upgrade_id)
	_progress_changed()
	return true


## A device stat: the tree's base value plus every unlocked upgrade's bonus.
func get_stat(device: String, stat: String) -> float:
	var tree: UpgradeTree = trees.get(device)
	if tree == null:
		return 0.0
	var value: float = tree.base_stats.get(stat, 0.0)
	for node in tree.nodes:
		if has_upgrade(device, node.id):
			value += node.effects.get(stat, 0.0)
	return value


func complete_mission(mission_id: String) -> void:
	if not completed_missions.has(mission_id):
		completed_missions.append(mission_id)
		skill_points += 1
	_progress_changed()


func _progress_changed() -> void:
	save_game()
	Events.upgrades_changed.emit()


func save_game() -> void:
	var data := {
		"skill_points": skill_points,
		"unlocked": unlocked,
		"completed_missions": completed_missions,
	}
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))


func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("Save file is unreadable; starting fresh.")
		return
	reset()
	skill_points = int(data.get("skill_points", 0))
	for mission in data.get("completed_missions", []):
		completed_missions.append(str(mission))
	var saved: Dictionary = data.get("unlocked", {})
	for device in saved:
		if unlocked.has(device):
			for upgrade_id in saved[device]:
				unlocked[device].append(str(upgrade_id))
