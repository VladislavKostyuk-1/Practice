extends StateIdle

class_name StateEnemyIdle

# Клас, похідний від StateIdle. Відповідає за функціонування ворогів в стані спокою.

@export var target_radius: float = 100 ## Відстань з якої ворог може помітити гравця

# Сцена, що відповідає за те що ворог міг помітити гравця
@onready var PlayerSeeker: PackedScene = preload("res://Entities/States/EnemyStates/Idle/player_seeker.tscn")
var player_seeker # Змінна, яка в якості значення буде зберігати екземпляр сцени PlayerSeeker після її створення


func _on_state_entered():
	# Створення екземпляру сцени PlayerSeeker та додання її до сцени.
	# call_deferred робить так, щоб метод було викликано не відразу, а тоді, коли він буде
	# готовим для виклику, аби уникнути помилок
	player_seeker = PlayerSeeker.instantiate()
	owner.add_child.call_deferred(player_seeker)
	
	# Код чеккає 2 кадри аби уникнути вильоту гри
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	# Надання сцені PlayerSceeker вказаного радіусу
	if player_seeker != null:
		player_seeker.Circle.shape.radius = target_radius


func _on_state_exited():
	# Після покидання цього стану, екземпляр player_seeker видаляється
	player_seeker.queue_free()
