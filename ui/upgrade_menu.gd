extends CanvasLayer
## Spend skill points on per-device upgrade trees. Toggle with Tab.
## Pauses the game while open.

const FONT_SIZE := 8
const DEVICE_ORDER := ["badge", "weapon", "drone", "vehicle"]

var _title: Label
var _columns: HBoxContainer
var _description: Label


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.04, 0.08, 0.92)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)

	var root := VBoxContainer.new()
	root.position = Vector2(16, 12)
	root.size = Vector2(448, 246)
	root.add_theme_constant_override("separation", 8)
	add_child(root)

	_title = _make_label("")
	root.add_child(_title)
	_columns = HBoxContainer.new()
	_columns.add_theme_constant_override("separation", 6)
	_columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_columns)
	_description = _make_label("Hover an upgrade to see what it does.")
	_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_description.custom_minimum_size = Vector2(448, 24)
	root.add_child(_description)

	Events.upgrades_changed.connect(_rebuild)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrades"):
		visible = not visible
		get_tree().paused = visible
		if visible:
			_rebuild()
		get_viewport().set_input_as_handled()


func _rebuild() -> void:
	_title.text = "UPGRADES   skill points: %d   (Tab to close)" % GameState.skill_points
	for child in _columns.get_children():
		child.queue_free()
	for device in DEVICE_ORDER:
		var tree: UpgradeTree = GameState.trees.get(device)
		if tree == null:
			continue
		var column := VBoxContainer.new()
		column.custom_minimum_size = Vector2(107, 0)
		column.add_child(_make_label(tree.display_name.to_upper()))
		for node in tree.nodes:
			column.add_child(_make_button(device, node))
		_columns.add_child(column)


func _make_button(device: String, node: UpgradeNode) -> Button:
	var button := Button.new()
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.clip_text = true
	if GameState.has_upgrade(device, node.id):
		button.text = "[x] " + node.display_name
		button.disabled = true
	else:
		button.text = "%s (%d)" % [node.display_name, node.cost]
		button.disabled = not GameState.can_unlock(device, node.id)
	var info := node.description
	if not node.requires.is_empty():
		var names: Array[String] = []
		for required in node.requires:
			names.append(GameState.trees[device].find(required).display_name)
		info += "  Needs: " + ", ".join(names) + "."
	button.mouse_entered.connect(func(): _description.text = info)
	button.focus_entered.connect(func(): _description.text = info)
	button.pressed.connect(func(): GameState.unlock(device, node.id))
	return button


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", FONT_SIZE)
	return label
