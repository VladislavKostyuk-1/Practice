extends StatManager

# Скрипт, похідний від класу StatManager.
# Управляє статами компоненту HealthComponent

# Змінна, що зберігає останнє значення стата max_health до його модифікації
var max_health_last: int

func _ready() -> void:
	max_health_last = owner.max_health
	default_values.max_health = owner.max_health
	default_values.damage_multiplier = owner.damage_multiplier
	default_values.healing_multiplier = owner.healing_multiplier
	create_values()


func _on_stat_updated(stat: String):
	match stat:
		# При модифікації максимального здоров'я, оновити поточне
		"max_health":
			owner.health *= get_current("max_health") / max_health_last
			max_health_last = get_current("max_health")
