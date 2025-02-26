extends Component

class_name ComponentHealth

# Компонент, відповідальний за зберігання здоров'я носія, а також виконання таких операцій
# як: отримання пошкоджень, лікування, смерть і тд.

signal health_updated

@export_group("Base")
@export var health_label: Label
@export var max_health: int = 100 ## Максимальне, та початкове, здоров'я носія
@export var damage_multiplier: float = 1 ## Множник отримання пошкоджень
@export var healing_multiplier: float = 1 ## Множник лікування

@export_group("Flinching")
@export var can_flinch: bool = true
@export var damage_to_flinch: int = 50
@export var hits_to_flinch: int = 3
@export var flinch_duration: float = 0.1
@export var flinch_cooldown: float = 1

var is_alive: bool = true
var flinch_duration_left: float = 0
var flinch_cooldown_left: float = 0
var time_since_last_hit: float = 0
var recent_hits: int = 0

# Поточне здоров'я носія
var health: int = 100 :
	set(value):
		health = value
		health_updated.emit(health)
		
		if health <= 0:
			is_alive = false
			StMachine.AnimTree.set("parameters/conditions/is_dead", true)
		
		if health_label:
			health_label.text = str(value)


func _ready() -> void:
	health = stat_manager.get_current("max_health")
	owner.add_to_group("HasHealth") # Носій додається до групи "HasHealth"


func _process(delta: float) -> void:
	if can_flinch:
		if time_since_last_hit < 1:
			time_since_last_hit += delta
		elif time_since_last_hit == 1:
			recent_hits = 0
			time_since_last_hit = 2
		
		flinch_cooldown_left = move_toward(flinch_cooldown_left, 0, delta)
		
		if flinch_duration_left > 0:
			flinch_duration_left = move_toward(flinch_duration_left, 0, delta)
		elif flinch_duration_left == 0:
			flinch_duration_left = -1
			StMachine.AnimTree.set("parameters/conditions/is_flinching", false)
			StMachine.AnimTree.set("parameters/conditions/is_not_flinching", true)


# Отримання пошкоджень
func take_damage(value: int):
	if is_alive:
		health -= value * stat_manager.get_current("damage_multiplier")
		
		if can_flinch and flinch_cooldown_left == 0:
			recent_hits += 1
			time_since_last_hit = 0
			
			if value >= damage_to_flinch or recent_hits >= hits_to_flinch:
				flinch_duration_left = flinch_duration
				flinch_cooldown_left = flinch_cooldown
				StMachine.AnimTree.set("parameters/conditions/is_flinching", true)
				StMachine.AnimTree.set("parameters/conditions/is_not_flinching", false)


# Лікування. Підвищити здоро'я вище максимального значення - не можна
func heal(value: int):
	health += value * stat_manager.get_current("healing_multiplier")
	health = min(stat_manager.get_current("max_health"), health)
