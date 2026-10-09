extends CharacterBody2D
## The Agent. Placeholder box art until real sprites exist.

const SPEED := 90.0
const JUMP_VELOCITY := -220.0
const GRAVITY := 600.0

var facing := 1


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * SPEED
	if dir != 0.0:
		facing = signi(int(dir))

	move_and_slide()
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(-5, -11, 10, 22), Color(0.2, 0.85, 1.0))
	# Visor shows which way the Agent faces.
	draw_rect(Rect2(1 if facing > 0 else -5, -8, 4, 2), Color.WHITE)
