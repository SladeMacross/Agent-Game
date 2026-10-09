class_name GuardSide
extends Guard
## A side-view guard: walks back and forth, falls with gravity.

const GRAVITY := 600.0

## How far it walks each way from where it starts.
@export var patrol_distance := 80.0

var _start_x := 0.0
var _dir := 1.0


func _ready() -> void:
	super()
	_start_x = position.x


func _patrol(_delta: float) -> void:
	if position.x > _start_x + patrol_distance:
		_dir = -1.0
	elif position.x < _start_x - patrol_distance:
		_dir = 1.0
	velocity.x = _dir * speed
	facing = Vector2(_dir, 0)


func _investigate(_delta: float) -> void:
	var dx := investigate_point.x - global_position.x
	if absf(dx) > 6.0:
		facing = Vector2(signf(dx), 0)
		velocity.x = signf(dx) * speed * 0.6
	else:
		velocity.x = 0.0


func _alert(_delta: float) -> void:
	velocity.x = 0.0
	var dx := investigate_point.x - global_position.x
	if dx != 0.0:
		facing = Vector2(signf(dx), 0)


func _apply_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()
