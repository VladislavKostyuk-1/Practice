extends AttackState

class_name StateSlimeJumping

@export var jump_speed: float = 110
@export var jump_height: float = 50
@export var jump_duration: float = 0.7

var duration_left: float
var started_jumping: bool = false


func _on_state_entered():
	get_parent().AnimTree.set("parameters/conditions/jump_ended", false)
	started_jumping = false


func _on_state_exited():
	get_parent().AnimTree.set("parameters/conditions/jump_ended", false)
	condition_not_met()
	started_jumping = false
	owner.position_z = 0


func _ready() -> void:
	owner.HurtBox.connect("damage_dealt", _on_damage_dealt)


func _physics_process(delta: float) -> void:
	if (is_active and started_jumping) or get_parent().AnimPlayer.current_animation == "JumpAttackEnd":
		duration_left = move_toward(duration_left, 0, delta)
		
		if duration_left > jump_duration * 0.5:
			owner.position_z = move_toward(owner.position_z,jump_height, jump_height * 4 * delta)
		else:
			owner.position_z = move_toward(owner.position_z, 0, jump_height * 4 * delta)
		
		if duration_left == 0:
			duration_left = -1
			owner.velocity *= 0.1
			get_parent().AnimTree.set("parameters/conditions/jump_ended", true)
		
		owner.move_and_slide()


func jump():
	owner.velocity = (owner.target.global_position - owner.global_position).normalized() * jump_speed
	duration_left = jump_duration
	started_jumping = true


func _on_damage_dealt():
	duration_left = 0
