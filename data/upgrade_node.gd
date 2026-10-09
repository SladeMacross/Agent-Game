class_name UpgradeNode
extends Resource
## One upgrade in a device's tree.

@export var id := ""
@export var display_name := ""
@export_multiline var description := ""
@export var cost := 1
## Upgrade ids in the same tree that must be unlocked first.
@export var requires: Array[String] = []
## stat name -> amount added to the device's base stat.
@export var effects: Dictionary = {}
