extends State

class_name AttackState

@export var attack_range: float = 100
@export var attack_cooldown: float = 0.5
@export var property_path: String


func condition_met() -> void:
	get_parent().AnimTree.set(property_path, true)


func condition_not_met() -> void:
	get_parent().AnimTree.set(property_path, false)
