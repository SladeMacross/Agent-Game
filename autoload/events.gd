extends Node
## Global signal bus. Systems talk through these so they don't need to
## know about each other.

## Something made a sound. Guards within `radius` hear it.
signal noise_made(origin: Vector2, radius: float, source: Node)
## The Agent's scanner fired a pulse.
signal scan_pulsed(origin: Vector2, radius: float, duration: float, through_walls: bool)
## A guard became fully alert.
signal player_spotted(by: Node)
## The Agent stepped into an exit or door.
signal exit_reached(zone: Node)
## Ends the current attempt (the level restarts).
signal mission_failed(reason: String)
## Short text for the HUD's center message.
signal hud_message(text: String)
## Skill points or unlocked upgrades changed.
signal upgrades_changed
