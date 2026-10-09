class_name AgentSide
extends Agent
## The Agent in side view: run, jump, gravity.

const SPEED := 90.0
const SNEAK_SPEED := 45.0
const JUMP_VELOCITY := -220.0
const GRAVITY := 600.0


func _move(delta: float) -> bool:
	var was_airborne := not is_on_floor()
	if was_airborne:
		velocity.y += GRAVITY * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * (SNEAK_SPEED if sneaking else SPEED)
	if dir != 0.0:
		facing = Vector2(signf(dir), 0)

	move_and_slide()
	if was_airborne and is_on_floor() and not sneaking:
		make_noise(run_noise_radius * 0.8)
	return dir != 0.0 and is_on_floor()
