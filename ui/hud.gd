extends CanvasLayer
## In-level HUD: controls hint, center message, scanner charge, skill points.

const FONT_SIZE := 8
const GREEN := Color(0.3, 1.0, 0.6)

@export_multiline var hint_text := ""

var _message: Label
var _scan_label: Label
var _scan_bar: ColorRect
var _points: Label


func _ready() -> void:
	layer = 10
	var hint := _label(Vector2(12, 10), hint_text)
	hint.modulate.a = 0.75

	_message = _label(Vector2(0, 120), "")
	_message.size = Vector2(480, 20)
	_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	_scan_label = _label(Vector2(12, 248), "SCAN")
	var back := ColorRect.new()
	back.position = Vector2(56, 253)
	back.size = Vector2(40, 3)
	back.color = Color(0, 0, 0, 0.6)
	add_child(back)
	_scan_bar = ColorRect.new()
	_scan_bar.position = back.position
	_scan_bar.size = back.size
	_scan_bar.color = GREEN
	add_child(_scan_bar)

	_points = _label(Vector2(380, 248), "")
	_points.size = Vector2(88, 12)
	_points.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	Events.hud_message.connect(_on_hud_message)


func _process(_delta: float) -> void:
	var agent := get_tree().get_first_node_in_group("player") as Agent
	if agent:
		var charge := 1.0 - agent.scanner.cooldown_ratio()
		_scan_bar.size.x = 40.0 * charge
		_scan_label.text = "SCAN" if charge < 1.0 else "SCAN  ready"
	_points.text = "Skill points: %d" % GameState.skill_points


func _on_hud_message(text: String) -> void:
	_message.text = text


func _label(pos: Vector2, text: String) -> Label:
	var label := Label.new()
	label.position = pos
	label.text = text
	label.add_theme_font_size_override("font_size", FONT_SIZE)
	add_child(label)
	return label
