class_name Awareness
extends Node
## A guard's suspicion meter. Seeing the Agent fills it (faster up close);
## it drains when the Agent is out of sight. Full = alert.

signal state_changed(state: State)

enum State { UNAWARE, SUSPICIOUS, ALERT }

const SUSPICIOUS_AT := 0.35

## Fill per second when seen at the edge of sight. Doubles point-blank.
@export var gain_rate := 1.2
@export var decay_rate := 0.25
## Seconds the guard stays suspicious after a noise or a glimpse.
@export var suspicion_hold := 3.0

var level := 0.0
var state := State.UNAWARE
var _hold_left := 0.0


func tick(delta: float, seeing: bool, closeness: float) -> void:
	if state == State.ALERT:
		return
	if seeing:
		level += gain_rate * (1.0 + closeness) * delta
		_hold_left = suspicion_hold / 2.0
	elif _hold_left > 0.0:
		_hold_left -= delta
	else:
		level -= decay_rate * delta
	level = clampf(level, 0.0, 1.0)
	_update_state()


func hear_noise() -> void:
	if state == State.ALERT:
		return
	level = maxf(level, SUSPICIOUS_AT)
	_hold_left = suspicion_hold
	_update_state()


func _update_state() -> void:
	var new_state := State.UNAWARE
	if level >= 1.0:
		new_state = State.ALERT
	elif level >= SUSPICIOUS_AT:
		new_state = State.SUSPICIOUS
	if new_state != state:
		state = new_state
		state_changed.emit(state)
