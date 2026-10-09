class_name GuardTopDown
extends Guard
## A top-down guard: walks a loop of points, looks around when suspicious.

## Route points, relative to where the guard starts. Empty = stand still.
@export var patrol_points: Array[Vector2] = []

var _origin := Vector2.ZERO
var _next := 0


func _ready() -> void:
	super()
	_origin = global_position


func _patrol(_delta: float) -> void:
	if patrol_points.is_empty():
		velocity = Vector2.ZERO
		return
	var to := _origin + patrol_points[_next] - global_position
	if to.length() < 3.0:
		_next = (_next + 1) % patrol_points.size()
		return
	velocity = to.normalized() * speed
	facing = to.normalized()


func _investigate(delta: float) -> void:
	var to := investigate_point - global_position
	if to.length() > 8.0:
		velocity = to.normalized() * speed * 0.6
		facing = to.normalized()
	else:
		velocity = Vector2.ZERO
		facing = facing.rotated(delta * 1.5)
