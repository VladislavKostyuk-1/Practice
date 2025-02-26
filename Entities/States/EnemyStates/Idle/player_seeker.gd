extends Node2D

# Сцена, що відповідає за те, аби ворог міг помітити гравця.

var target: CharacterBody2D = null # Гравець, що знаходиться в радіусі сцени
# Кількість кадрів, що пройшло з моменту входження гравця у радіус помітності.
# Необхідно для уникнення помилок пов'язаних з колізією
var frame: int = 0 

@onready var Area := $Area2D ## Нод типу Area2D, що відповідає за помічення гравця
@onready var Circle := $Area2D/CollisionShape2D ## Зона ноди Area
@onready var Raycast := $RayCast2D ## Нод типу Raycast2D, що перевіряє чи наявні перешкоди між ворогом та гравцем


func _physics_process(_delta: float) -> void:
	# Якщо гравець увійшов в зону помітності, Raycast починає вказувати на гравця.
	# Але перед початком перевірки наявності перешкод, необхідно почекати 2 кадри.
	# Якщо перешкод між гравцем то ворогом немає, то змінній target ворога надається
	# посилання на гравця.
	if target:
		Raycast.target_position = target.global_position - global_position
		frame = min(2, frame + 1)
		
		if frame == 2 and not Raycast.is_colliding():
			get_parent().target = target
	else:
		frame = 0
		Raycast.target_position = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	target = body


func _on_area_2d_body_exited(_body: Node2D) -> void:
	target = null
