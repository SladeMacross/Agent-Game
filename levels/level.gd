class_name Level
extends Node2D
## Root script for every playable area, hub or mission. Handles exits,
## being spotted, failing and restarting.

enum Perspective { SIDE_VIEW, TOP_DOWN }

## Empty for hubs. Set for missions; finishing one awards a skill point once.
@export var mission_id := ""
@export var perspective := Perspective.SIDE_VIEW

var _over := false


func _ready() -> void:
	Events.exit_reached.connect(_on_exit_reached)
	Events.player_spotted.connect(_on_player_spotted)
	Events.mission_failed.connect(_fail)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		SceneRouter.reload()


func _on_exit_reached(zone: ExitZone) -> void:
	if _over:
		return
	_over = true
	if zone.completes_mission and not mission_id.is_empty():
		GameState.complete_mission(mission_id)
		Events.hud_message.emit("MISSION COMPLETE")
		await get_tree().create_timer(1.5).timeout
	SceneRouter.go_to(zone.target_scene)


func _on_player_spotted(_by: Node) -> void:
	_fail("SPOTTED")


func _fail(reason: String) -> void:
	if _over:
		return
	_over = true
	Events.hud_message.emit(reason + " - restarting")
	await get_tree().create_timer(1.2).timeout
	SceneRouter.reload()
