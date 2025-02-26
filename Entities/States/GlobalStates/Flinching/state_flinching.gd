extends State


func _physics_process(delta: float) -> void:
	if is_active:
		owner.velocity = owner.velocity.move_toward(Vector2.ZERO, 20 * delta)
		owner.move_and_slide()
