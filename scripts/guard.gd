extends CharacterBody2D
## A patrolling guard with a vision cone. Walls block its sight.

signal spotted_player

const GRAVITY := 600.0
const ARMOR_NAMES := ["WEAK", "MEDIUM", "HEAVY"]

@export var patrol_distance := 80.0
@export var speed := 30.0
@export var view_range := 120.0
@export var view_angle_deg := 50.0
@export_enum("Weak", "Medium", "Heavy") var armor := 0

## Set by the level while the player holds Scan.
var revealed := false
var alerted := false
var _start_x := 0.0
var _dir := 1


func _ready() -> void:
	_start_x = position.x


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = 0.0 if alerted else _dir * speed
	move_and_slide()

	if position.x > _start_x + patrol_distance:
		_dir = -1
	elif position.x < _start_x - patrol_distance:
		_dir = 1

	if not alerted and _can_see_player():
		alerted = true
		spotted_player.emit()
	queue_redraw()


func _eye() -> Vector2:
	return global_position + Vector2(0, -8)


func _can_see_player() -> bool:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return false
	var to_player := player.global_position - _eye()
	if to_player.length() > view_range:
		return false
	if absf(Vector2(_dir, 0).angle_to(to_player)) > deg_to_rad(view_angle_deg) / 2.0:
		return false
	var query := PhysicsRayQueryParameters2D.create(_eye(), player.global_position)
	query.exclude = [get_rid()]
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.collider == player


func _draw() -> void:
	# Vision cone, drawn in local space.
	var half := deg_to_rad(view_angle_deg) / 2.0
	var eye := Vector2(0, -8)
	var points := PackedVector2Array([eye])
	for i in 9:
		var a := lerpf(-half, half, i / 8.0)
		points.append(eye + Vector2(_dir, 0).rotated(a) * view_range)
	var cone := Color(1, 0.2, 0.2, 0.35) if alerted else Color(1, 0.9, 0.3, 0.18)
	draw_colored_polygon(points, cone)

	draw_rect(Rect2(-6, -12, 12, 24), Color(0.9, 0.3, 0.3) if alerted else Color(0.75, 0.55, 0.3))

	if revealed:
		var font := ThemeDB.fallback_font
		draw_string(font, Vector2(-20, -18), ARMOR_NAMES[armor], HORIZONTAL_ALIGNMENT_CENTER, 40, 8, Color(0.4, 1, 0.6))
