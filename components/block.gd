@tool
class_name Block
extends StaticBody2D
## A solid placeholder rectangle (floor, wall, building). Set `size` in the
## Inspector; the collision shape follows. Swap for tiles once there's art.

@export var size := Vector2(32, 32):
	set(value):
		size = value
		_apply()
@export var color := Color(0.22, 0.24, 0.32):
	set(value):
		color = value
		queue_redraw()

var _shape: CollisionShape2D


func _ready() -> void:
	_shape = CollisionShape2D.new()
	_shape.shape = RectangleShape2D.new()
	add_child(_shape)
	_apply()


func _apply() -> void:
	if _shape:
		(_shape.shape as RectangleShape2D).size = size
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(-size / 2.0, size), color)
