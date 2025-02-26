extends ResourceStatManager

class_name AttackInfo

@export var damage: int = 10
@export var knockback: float = 20
@export var attacker_as_knockback_origin: bool = true
@export var can_friendly_fire: bool = false

var knockback_origin: Vector2
var attacker: CharacterBody2D


func _init() -> void:
	default_values.damage = damage
	default_values.knockback = knockback
	create_values()
