class_name Guard
extends CharacterBody2D
## Shared guard logic for every view: sight, hearing, suspicion and what to
## do in each awareness state. Subclasses supply the movement.

const ARMOR_NAMES := ["WEAK", "MEDIUM", "HEAVY"]

@export_enum("Weak", "Medium", "Heavy") var armor := 0
@export var speed := 30.0
@export var body_size := Vector2(12, 24)

var facing := Vector2.RIGHT
## Last place the guard saw or heard something.
var investigate_point := Vector2.ZERO

@onready var vision: VisionSensor = $VisionSensor
@onready var hearing: HearingSensor = $HearingSensor
@onready var awareness: Awareness = $Awareness
@onready var scannable: Scannable = $Scannable


func _ready() -> void:
	add_to_group("guards")
	hearing.heard.connect(_on_heard)
	awareness.state_changed.connect(_on_state_changed)
	scannable.title = ARMOR_NAMES[armor] + " ARMOR"


func _physics_process(delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	var seeing := vision.can_see(player)
	if seeing:
		investigate_point = player.global_position
	awareness.tick(delta, seeing, vision.closeness(player) if seeing else 0.0)

	match awareness.state:
		Awareness.State.UNAWARE:
			_patrol(delta)
		Awareness.State.SUSPICIOUS:
			_investigate(delta)
		Awareness.State.ALERT:
			_alert(delta)
	_apply_movement(delta)

	vision.facing = facing
	vision.tint = _cone_color()
	queue_redraw()


## Override: normal patrol route.
func _patrol(_delta: float) -> void:
	pass


## Override: head toward investigate_point and look around.
func _investigate(_delta: float) -> void:
	pass


## Override: stop and face the Agent. (Shooting comes with the combat system.)
func _alert(_delta: float) -> void:
	velocity = Vector2.ZERO
	_face(investigate_point)


## Override: actually move the body (gravity, move_and_slide...).
func _apply_movement(_delta: float) -> void:
	move_and_slide()


func _face(point: Vector2) -> void:
	var to := point - global_position
	if to.length() > 1.0:
		facing = to.normalized()


func _on_heard(origin: Vector2) -> void:
	if awareness.state != Awareness.State.ALERT:
		investigate_point = origin
		awareness.hear_noise()


func _on_state_changed(state: Awareness.State) -> void:
	if state == Awareness.State.ALERT:
		Events.player_spotted.emit(self)


func _cone_color() -> Color:
	match awareness.state:
		Awareness.State.SUSPICIOUS:
			return Color(1, 0.6, 0.2, 0.25)
		Awareness.State.ALERT:
			return Color(1, 0.2, 0.2, 0.35)
	return Color(1, 0.9, 0.3, 0.18)


func _draw() -> void:
	var c := Color(0.75, 0.55, 0.3)
	if awareness.state == Awareness.State.ALERT:
		c = Color(0.9, 0.3, 0.3)
	draw_rect(Rect2(-body_size / 2.0, body_size), c)
	# Suspicion meter above the head.
	if awareness.level > 0.0:
		var top := -body_size.y / 2.0 - 5.0
		draw_rect(Rect2(-8, top, 16, 2), Color(0, 0, 0, 0.6))
		draw_rect(Rect2(-8, top, 16 * awareness.level, 2), _cone_color().lightened(0.3))
