class_name AgentTopDown
extends Agent
## The Agent in top-down view: walk in eight directions.

const SPEED := 80.0
const SNEAK_SPEED := 40.0


func _move(_delta: float) -> bool:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * (SNEAK_SPEED if sneaking else SPEED)
	if dir != Vector2.ZERO:
		facing = dir.normalized()
	move_and_slide()
	return dir != Vector2.ZERO
