class_name Agent
extends CharacterBody2D
## Shared Agent logic for every view: scanning, sneaking, footstep noise,
## death. Subclasses only handle movement (_move).

const STEP_INTERVAL := 0.3

## How far running footsteps carry. Sneaking is silent.
@export var run_noise_radius := 70.0
@export var body_size := Vector2(10, 22)

var facing := Vector2.RIGHT
var sneaking := false
var _step_timer := 0.0

@onready var scanner: Scanner = $Scanner
@onready var health: Health = $Health


func _ready() -> void:
	add_to_group("player")
	health.died.connect(func(): Events.mission_failed.emit("AGENT DOWN"))


func _physics_process(delta: float) -> void:
	sneaking = Input.is_action_pressed("sneak")
	var moving := _move(delta)
	if Input.is_action_just_pressed("scan"):
		scanner.try_scan()
	_step_timer -= delta
	if moving and not sneaking and _step_timer <= 0.0:
		make_noise(run_noise_radius)
		_step_timer = STEP_INTERVAL
	queue_redraw()


## Moves the body for this frame. Returns true while walking/running.
func _move(_delta: float) -> bool:
	return false


func make_noise(radius: float) -> void:
	Events.noise_made.emit(global_position, radius, self)


func _draw() -> void:
	var c := Color(0.2, 0.85, 1.0)
	if sneaking:
		c = c.darkened(0.45)
	draw_rect(Rect2(-body_size / 2.0, body_size), c)
	draw_line(Vector2.ZERO, facing * (body_size.x / 2.0 + 3.0), Color.WHITE)
