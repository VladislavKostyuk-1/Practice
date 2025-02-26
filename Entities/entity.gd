extends CharacterBody2D

class_name Entity

# Основний клас сутностей

@export var BoundBox: CollisionShape2D
@export var HurtBox: Area2D
@export var HitBox: Area2D
@export var StMachine: StateMachine ## Машина станів сутності
## Чи будуть працювати методі _physics_process() пов'язані з цією сутністю
@export var is_active: bool = true:
	set(value):
		set_physics_process(value)
		
		if StMachine:
			StMachine.is_active = value
@export var affected_by_z: Array[Node2D] ## Ноди, позиція яких залежить від фейкової висоти


var look_direction_vector: Vector2 = Vector2(0, 1) ## Напрям погляду сутності у форматі вектора
var look_direction_angle: float = 0 ## Напрям погляду сутносіт у форматі кута

var position_z: float = 0: ## Фейкова висота
	set(value): 
		var difference = value - position_z
		position_z = value
		
		z_index = starting_z + value
		
		for affected in affected_by_z:
			affected.position.y -= difference


@onready var starting_z: int = z_index


func _physics_process(delta: float) -> void:
	if StMachine.blendspace_coords == Vector2.ZERO:
		look_direction_vector = Vector2(0, 1)
	else:
		look_direction_vector = StMachine.blendspace_coords
	
	look_direction_angle = GlobalFuncs.vector_to_angle(look_direction_vector)
	
	_on_physics_process(delta)


# Funcs

func rotate_the_hurtbox(locked_by_90: bool = true) -> void:
	if not locked_by_90:
		HurtBox.rotation_degrees = look_direction_angle
	
	else:
		var closest = GlobalFuncs.find_closest_vector(look_direction_vector, [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)])
		HurtBox.rotation_degrees = GlobalFuncs.vector_to_angle(closest)


func _on_ready() -> void:
	pass


func _on_physics_process(delta: float) -> void:
	pass
