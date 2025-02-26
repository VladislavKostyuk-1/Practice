extends Entity

class_name Player

# Клас, похідний від класу Entity, відповідає за управління гравцем

# input_dir - вектор, значення якого залежить від того, які клавіші управління що відповідають за
# пересування зараз натиснено
var input_dir: Vector2
var dir: Vector2 # Нормалізований вектор input_dir
var target_velocity: Vector2 # Фінальна швидкість, якої буде намагатися досягти гравець

@export var speed: float = 20 ## Максимальна швидкість пересування гравця
## Час, необхідний гравцю для досягнення максимальної швидкості у секундах
@export var time_to_accelerate: float = 0.1


func _on_physics_process(delta: float) -> void:
	# Отримання напряму ходьби
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	dir = input_dir.normalized()
	
	# Перед тим як задати значення вектору target_velocity, перевіряється чи знаходиться зараз
	# гравець в якомусь стані із машини станів, а також чи дозволяє поточний стан гравцю рухатись.
	# Якщо ні - target_velocity буде надано нульове значення
	if StMachine.current_state and StMachine.current_state.can_move:
		target_velocity = dir * speed
	else:
		target_velocity = Vector2.ZERO
	
	# Швидкість гравця встановлюється не відразу, замість цього вона кожного кадру наближається до
	# target_velocity таким чином, або досягнення повної швидкості зайняло стільки часу, скільки вказано
	# в time_to_accelerate
	velocity = velocity.move_toward(target_velocity, speed / time_to_accelerate * delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Primary"):
		HurtBox.set_is_active(true)
