extends State

class_name StateChase

# Стан, в якому ворог переслідує свою ціль.

## Відстань, яку цілі необхідно відійти від ворога, аби ворог втратив свою ціль
@export var target_lost_range: float = 400
@export var attack_states: Array[AttackState]

var target_velocity
var attack_cooldown

func _on_state_entered():
	attack_cooldown = 0


func _physics_process(delta: float) -> void:
	if is_active and owner.target:
		attack_cooldown += delta
		
		# Задання дереву анімацій значення в blendspace
		get_parent().AnimTree.set("parameters/Chase/blend_position", get_parent().blendspace_coords)
		
		# Ворог завжди пересувається до гравця напряму, ігноруючи перешкоди
		target_velocity = (owner.target.global_position - owner.global_position).normalized() * 50
		owner.velocity = owner.velocity.move_toward(target_velocity, 200 * delta)
		owner.move_and_slide()
		
		
		for state in attack_states:
			if attack_cooldown >= state.attack_cooldown and owner.global_position.distance_to(owner.target.global_position) <= state.attack_range:
				if owner.LineOfSight.is_colliding() == false:
					state.condition_met()
		
		# Код, що відповідає за втрату цілі
		if owner.global_position.distance_to(owner.target.global_position) > target_lost_range:
			owner.target = null
