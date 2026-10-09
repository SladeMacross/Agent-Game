@tool
class_name ExitZone
extends Area2D
## A door or exit. When the Agent walks in, the level decides what happens
## (finish the mission, or just move to `target_scene`).

@export_file("*.tscn") var target_scene := ""
## True for a mission's goal; false for an ordinary door.
@export var completes_mission := false
@export var size := Vector2(24, 24):
	set(value):
		size = value
		_apply()

var _shape: CollisionShape2D


func _ready() -> void:
	collision_layer = 8
	collision_mask = 2
	_shape = CollisionShape2D.new()
	_shape.shape = RectangleShape2D.new()
	add_child(_shape)
	_apply()
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)


func _apply() -> void:
	if _shape:
		(_shape.shape as RectangleShape2D).size = size
	queue_redraw()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Events.exit_reached.emit(self)


func _draw() -> void:
	var tint := Color(0.3, 1.0, 0.5, 0.35) if completes_mission else Color(0.4, 0.7, 1.0, 0.35)
	draw_rect(Rect2(-size / 2.0, size), tint)
