class_name Health
extends Node
## Hit points. Combat is lethal, so most things start with very few.

signal changed(current: int, maximum: int)
signal died

@export var max_health := 1

@onready var current := max_health


func damage(amount: int) -> void:
	if current <= 0:
		return
	current = maxi(current - amount, 0)
	changed.emit(current, max_health)
	if current == 0:
		died.emit()


func heal(amount: int) -> void:
	if current <= 0:
		return
	current = mini(current + amount, max_health)
	changed.emit(current, max_health)
