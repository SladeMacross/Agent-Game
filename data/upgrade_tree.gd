class_name UpgradeTree
extends Resource
## A device's upgrade tree: its base stats and the upgrades that change them.

@export var device_id := ""
@export var display_name := ""
## stat name -> starting value
@export var base_stats: Dictionary = {}
@export var nodes: Array[UpgradeNode] = []


func find(upgrade_id: String) -> UpgradeNode:
	for node in nodes:
		if node.id == upgrade_id:
			return node
	return null
