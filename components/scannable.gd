class_name Scannable
extends Node2D
## Something the scanner can reveal: a guard's armor, a hidden path, a
## door's purpose. Shows brackets and text for a few seconds after a scan.

@export var title := ""
@export_multiline var details := ""
@export var bracket_size := Vector2(18, 28)

var _time_left := 0.0


func _ready() -> void:
	z_index = 50
	Events.scan_pulsed.connect(_on_scan_pulsed)


func is_revealed() -> bool:
	return _time_left > 0.0


func _on_scan_pulsed(origin: Vector2, radius: float, duration: float, through_walls: bool) -> void:
	if global_position.distance_to(origin) > radius:
		return
	if not through_walls and not _clear_line_from(origin):
		return
	_time_left = duration
	queue_redraw()


func _clear_line_from(origin: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(origin, global_position, 1)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func _process(delta: float) -> void:
	if _time_left > 0.0:
		_time_left -= delta
		queue_redraw()


func _draw() -> void:
	if not is_revealed():
		return
	var c := Color(0.3, 1.0, 0.6)
	var h := bracket_size / 2.0
	for sx in [-1, 1]:
		for sy in [-1, 1]:
			var corner := Vector2(h.x * sx, h.y * sy)
			draw_line(corner, corner + Vector2(-4 * sx, 0), c)
			draw_line(corner, corner + Vector2(0, -4 * sy), c)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-40, -h.y - 3), title, HORIZONTAL_ALIGNMENT_CENTER, 80, 8, c)
	if not details.is_empty():
		draw_string(font, Vector2(-40, h.y + 9), details, HORIZONTAL_ALIGNMENT_CENTER, 80, 8, c)
