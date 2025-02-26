extends Node2D

# Цей скрипт прив'язується до ноду, що являється батьківським до всіх компонентів присутніх на сцені.
# Містить в собі словник, що зберігає посилання на інші компоненти.
# !!! Можливо цей срипт стане не потрібним у майбутньому та буде видалений

var components: Dictionary


func _ready() -> void:
	for component in get_children():
		if component is Component:
			var new_dict: Dictionary = {component.component_name: component}
			components.merge(new_dict)
