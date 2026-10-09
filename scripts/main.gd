extends Node2D
## Test room for side-view infiltration. Level geometry is built from
## rectangles until there's real tile art.

## Hold Scan to slow time; this tests the "real-time with a scan mode" option.
const SCAN_TIME_SCALE := 0.3

const SOLIDS := [
	Rect2(0, 240, 480, 30),   # floor
	Rect2(0, 0, 480, 8),      # ceiling
	Rect2(0, 0, 8, 270),      # left wall
	Rect2(472, 0, 8, 270),    # right wall
	Rect2(90, 205, 30, 35),   # crate
	Rect2(120, 172, 240, 8),  # walkway (blocks guard sight from below)
]
const EXIT := Rect2(440, 210, 30, 30)

var _hud: Label
var _done := false


func _ready() -> void:
	Engine.time_scale = 1.0
	for r in SOLIDS:
		_add_solid(r)
	_add_exit()
	_add_hud()
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.spotted_player.connect(_on_spotted)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	var scanning := Input.is_action_pressed("scan") and not _done
	Engine.time_scale = SCAN_TIME_SCALE if scanning else 1.0
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.revealed = scanning


func _add_solid(r: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = r.get_center()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = r.size
	shape.shape = rect
	body.add_child(shape)
	var vis := ColorRect.new()
	vis.color = Color(0.22, 0.24, 0.32)
	vis.position = -r.size / 2.0
	vis.size = r.size
	body.add_child(vis)
	add_child(body)


func _add_exit() -> void:
	var area := Area2D.new()
	area.position = EXIT.get_center()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = EXIT.size
	shape.shape = rect
	area.add_child(shape)
	var vis := ColorRect.new()
	vis.color = Color(0.3, 1.0, 0.5, 0.35)
	vis.position = -EXIT.size / 2.0
	vis.size = EXIT.size
	area.add_child(vis)
	area.body_entered.connect(_on_exit_entered)
	add_child(area)


func _add_hud() -> void:
	var layer := CanvasLayer.new()
	_hud = Label.new()
	_hud.position = Vector2(12, 10)
	_hud.add_theme_font_size_override("font_size", 8)
	_hud.text = "A/D move   Space jump   hold Q scan   R restart\nReach the green exit without being seen."
	layer.add_child(_hud)
	add_child(layer)


func _on_spotted() -> void:
	if _done:
		return
	_done = true
	_hud.text = "SPOTTED! Restarting..."
	get_tree().create_timer(1.0, true, false, true).timeout.connect(get_tree().reload_current_scene)


func _on_exit_entered(body: Node) -> void:
	if _done or not body.is_in_group("player"):
		return
	_done = true
	_hud.text = "MISSION COMPLETE   (R to play again)"
