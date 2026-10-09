class_name Scanner
extends Node2D
## The badge scanner. Sends a pulse that reveals nearby Scannables.
## Range, cooldown and reveal time come from the badge's upgrade tree.

const DEVICE := "badge"

var cooldown_left := 0.0
var _ring_t := 1.0
var _ring_radius := 0.0


func _ready() -> void:
	z_index = 40


func try_scan() -> bool:
	if cooldown_left > 0.0:
		return false
	var radius := GameState.get_stat(DEVICE, "scan_radius")
	Events.scan_pulsed.emit(
		global_position,
		radius,
		GameState.get_stat(DEVICE, "scan_reveal_time"),
		GameState.get_stat(DEVICE, "scan_through_walls") > 0.0
	)
	cooldown_left = GameState.get_stat(DEVICE, "scan_cooldown")
	_ring_radius = radius
	_ring_t = 0.0
	return true


## 1 right after scanning, 0 when ready again.
func cooldown_ratio() -> float:
	var total := GameState.get_stat(DEVICE, "scan_cooldown")
	return 0.0 if total <= 0.0 else clampf(cooldown_left / total, 0.0, 1.0)


func _process(delta: float) -> void:
	cooldown_left = maxf(cooldown_left - delta, 0.0)
	if _ring_t < 1.0:
		_ring_t = minf(_ring_t + delta * 2.5, 1.0)
		queue_redraw()


func _draw() -> void:
	if _ring_t < 1.0:
		draw_arc(Vector2.ZERO, _ring_radius * _ring_t, 0.0, TAU, 48, Color(0.3, 1.0, 0.6, 1.0 - _ring_t), 1.0)
