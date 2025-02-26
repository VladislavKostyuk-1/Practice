extends Entity

class_name Enemy

# Клас, похідний від класу Entity. Зберігає у собі інформацію необхідну для поведінки всіх ворогів.

signal target_acquired # Сигнал, що подається коли у ворога з'являється ціль
signal target_lost # Сигнал, зо подається коли у ворога зникає ціль


@export var LineOfSight: RayCast2D

func _on_physics_process(_delta):
	if LineOfSight and target:
		LineOfSight.target_position = target.global_position - global_position
	elif LineOfSight and target == null:
		LineOfSight.target_position = Vector2.ZERO

# Змінна, що зберігає поточну ціль ворога. Ця змінна використовує сеттер, аби подати сигнал
# target_acquired або target_lost в залежності від присвоєного значення.
var target: CharacterBody2D :
	set(value):
		target = value
		
		if value != null:
			target_acquired.emit(value)
		else:
			target_lost.emit()
