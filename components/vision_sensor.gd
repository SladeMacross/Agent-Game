class_name VisionSensor
extends Node2D
## A cone of sight. Works in side view and top-down: the owner sets `facing`.
## Walls (world layer) block it. Place this node at the eyes.

@export var view_range := 120.0
@export var view_angle_deg := 50.0
## Layers that stop or receive sight: world + player.
@export_flags_2d_physics var sight_mask := 3

var facing := Vector2.RIGHT
var tint := Color(1, 0.9, 0.3, 0.18)


func can_see(target: Node2D) -> bool:
	if target == null:
		return false
	var to_target := target.global_position - global_position
	if to_target.length() > view_range:
		return false
	if absf(facing.angle_to(to_target)) > deg_to_rad(view_angle_deg) / 2.0:
		return false
	var query := PhysicsRayQueryParameters2D.create(global_position, target.global_position, sight_mask)
	var body := get_parent() as CollisionObject2D
	if body:
		query.exclude = [body.get_rid()]
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.collider == target


## 1 when the target is right here, 0 at the edge of sight.
func closeness(target: Node2D) -> float:
	return clampf(1.0 - global_position.distance_to(target.global_position) / view_range, 0.0, 1.0)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var half := deg_to_rad(view_angle_deg) / 2.0
	var points := PackedVector2Array([Vector2.ZERO])
	for i in 13:
		points.append(facing.rotated(lerpf(-half, half, i / 12.0)) * view_range)
	draw_colored_polygon(points, tint)
