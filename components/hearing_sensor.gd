class_name HearingSensor
extends Node2D
## Hears noises sent through Events.noise_made. Sound passes through walls.

signal heard(origin: Vector2)

## Multiplies every noise's radius. Above 1 = sharper ears.
@export var sensitivity := 1.0


func _ready() -> void:
	Events.noise_made.connect(_on_noise_made)


func _on_noise_made(origin: Vector2, radius: float, source: Node) -> void:
	if source == get_parent():
		return
	if global_position.distance_to(origin) <= radius * sensitivity:
		heard.emit(origin)
