extends Resource

class_name ResourceStatManager

# Цей клас відповідальний за динамічне управління статами
# !!!Примітка - код цього класу ідентичний до коду в StatManager, єдина відмінність - цей
# клас є дочирнім до класу Resource, тобто він призначений для роботи з ресурсами

signal stat_updated # Цей сигнал подається коли значення якогось стату було оновлено

# Словник, що в якості ключив зберігає назви статів у форматі String, а в якості значень - значення
# статів за замовчуванням. Цей словник необхідно заповнювати вручну в скрипті, що походить від цього.
# Після заповнення цього словника необхідно викликати функцію create_values().
var default_values = {

}

# Словник, що зберігає значення унаступному форматі:
# {stat_name:String : [current_value:int/float, base_value:int/float, additors:Array, multipliers:Array]}
# Цей словник заповнюється автоматично функцією create_calues() та використовується для зберігання всієї
# інформації про стати
var values = {
	
}


func _ready():
	create_values()


# Ця функція заповнює словник values значеннями із словника default_values, а також змінює значення
# кожного ключа для зберігання необхідної інформації
func create_values():
	values.merge(default_values)
	for value in values:
		values[value] = [values[value], values[value], [], []]
	
	update_all_stats()


# Використовується для отримання поточного значення стата
func get_current(stat: String):
	return values[stat][0]


# Використовується для встановлення поточного значення стата
func set_current(stat: String, value):
	values[stat][0] = value


# Використовується для отримання базового значення стата
func get_base(stat: String):
	return values[stat][1]


# Використовується для отримання суматорів стата
func get_additors(stat: String):
	return values[stat][2]


# Використовується для отримання множників стата
func get_multipliers(stat: String):
	return values[stat][3]


# Оновлює значення стата, спочатку змінюючи його поточне значення на бозове, потім
# додає до поточного значення усі значення із масива суматорів, а потом перемножує на усі значення
# із масива множників
func update_stat(stat: String):
	values[stat][0] = get_base(stat)
	
	for i in get_additors(stat):
		values[stat][0] += i
	
	for i in get_multipliers(stat):
		values[stat][0] *= i
	
	stat_updated.emit(stat)
	_on_stat_updated(stat)


# Викликає функцію update_stat() для кожного стата
func update_all_stats():
	for stat in values:
		update_stat(stat)


# Використовується для додавання/видалення певної величини із масиву суматорів
func update_additors(stat: String, add: bool, value):
	if add:
		values[stat][2].append(value)
	else:
		values[stat][2].erase(value)
	
	update_stat(stat) 


# Використовується для додавання/видалення певної величини із масиву множників
func update_multipliers(stat: String, add: bool, value):
	if add:
		values[stat][3].append(value)
	else:
		values[stat][3].erase(value)
	
	update_stat(stat) 


# Цей метод викликається у кінці функції update_stat(), з назвою стату в якості параметру. В цьому
# скрипті нічого не робить, але цю функцію можна за необхідності переписати у похідному скрипті
# для виконання певних дій при оновленні певного стата
func _on_stat_updated(_stat: String):
	pass
