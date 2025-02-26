extends State

func _on_state_entered():
	owner.position_z = -1
	owner.HurtBox.set_is_active(false)
	owner.HitBox.set_is_active(false)


func _physics_process(delta: float) -> void:
	if is_active: 
		if owner.velocity != Vector2.ZERO:
			owner.velocity = owner.velocity.move_toward(Vector2.ZERO, 300 * delta)
			owner.move_and_slide()
		else:
			owner.is_active = false
			owner.BoundBox.set_deferred("disabled", true)
