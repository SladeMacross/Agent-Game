extends CanvasLayer
## Changes scenes with a short fade to black.

const FADE_TIME := 0.25

var _fade: ColorRect
var _busy := false


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.modulate.a = 0.0
	add_child(_fade)


func go_to(path: String) -> void:
	if _busy or path.is_empty():
		return
	_busy = true
	await _fade_to(1.0)
	get_tree().paused = false
	get_tree().change_scene_to_file(path)
	await _fade_to(0.0)
	_busy = false


func reload() -> void:
	var current := get_tree().current_scene
	if current:
		go_to(current.scene_file_path)


func _fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, "modulate:a", alpha, FADE_TIME)
	await tween.finished
