extends Node2D

class_name StateMachine

signal state_changed

# Клас машини сутностей. Відповідає за переходи між станами з використанням
# дерева анімацій, а також за циклічність анімацій, та напрям їх погляду.

var is_active: bool = true:
	set(value):
		set_physics_process(value)
		for state_ in states_dict.values():
			state_.set_physics_process(value)

var states_dict: Dictionary ## Словник з форматом {Назва_анімації : Стан}
var current_state: State ## Поточний стан сутності
var last_anim: String ## Остання програна анімація
var blendspace_coords: Vector2 = Vector2(0, -1) ## Координати в blendspace дерева анімації
var frame: int = 0 ## Кількість кадрів що пройшло від початку останньої анімації
var anim_tree_state_machine ## Машина станів дерева анімацій

@export var AnimPlayer: AnimationPlayer ## Програвач анімацій
@export var AnimTree: AnimationTree ## Дерево анімацій


func _ready() -> void:
	setup_states()
	
	anim_tree_state_machine = AnimTree.get("parameters/playback")
	
	# Підключення сигналів що сповіщують про початок та кінець анімації
	AnimTree.connect("animation_started", _on_animation_tree_animation_started)
	AnimTree.connect("animation_finished", _on_animation_tree_animation_finished)
	
	# Увімкнення програвача та дерева анімацій
	AnimPlayer.active = true
	AnimTree.active = true
	
	# Надання дереву можливості перейти з одніє анімаціїї в ту ж саму, що дозволяє зациклювати їх
	AnimTree.tree_root.allow_transition_to_self = true
	
	_on_ready()


func _physics_process(_delta):
	# Перевірка чи поточний стан не є порожнім значенням
	if current_state:
		# Надання значення змінній blendspace_coords в залежності від налаштування
		# look_direction поточної змінної
		
		# Змінна frame необхідна для того, щоб якщо block_direction_change == false,
		# то сутність змінить напрям свого погляду ЛИШЕ при переході в новий стан
		frame = min(3, frame + 1)
		
		if not (current_state.block_direction_change and frame == 2):
			match current_state.look_direction:
				current_state.LOOK_DIRECTION.MOUSE:
					blendspace_coords = (get_global_mouse_position() - owner.global_position).normalized()
				current_state.LOOK_DIRECTION.MOVEMENT:
					blendspace_coords = owner.input_dir
				current_state.LOOK_DIRECTION.VELOCITY:
					blendspace_coords = (owner.velocity).normalized()
				current_state.LOOK_DIRECTION.TARGET:
					if owner.target:
						blendspace_coords = (owner.target.global_position - owner.global_position).normalized()
		
		if frame == 2 and current_state.rotate_hurtbox_on_start:
			owner.rotate_the_hurtbox(current_state.lock_hitbox_rotation_by_90)


# Функція для переходу в новий стан.
# Спочатку відбувається вихід з поточного стану, а потім знаходиться потрібний стан,
# використавши назву щойно початої анімації як ключ в словнику states_dict.
func enter_state(anim_name: String):
	if current_state:
		current_state.exit_state()
	
	current_state = states_dict[anim_name]
	current_state.enter_state()
	
	state_changed.emit(current_state)
	
	$"../StateLabel".text = current_state.state_name


# Ця функція завпонює словник states_dict.
# Фунція бере кожну назву анімації з масиву anim_names кожного стану, і створює для кожної
# з них новий елемент, використвуючи назву анімації як ключ, а стан - як значення. Таким чином
# відразу декілька анімацій можуть бути прив'язані до одного й того ж стану.
func setup_states():
	for state1 in get_children():
		if state1 is State:
			for anim_name in state1.anim_names:
				var new_state: Dictionary = {anim_name : state1}
				states_dict.merge(new_state)


# Функція, що викликається в кінці функції ready(). Використвується в похідних скриптах,
# аби функція ready() не припиняла свою роботу.
func _on_ready() -> void:
	pass


# Signal handlers

# Цей сигнал викликається коли деево анімацій почає грати нову анімацію.
# Аби виконати перехід до нового стану, функція перевіряє який стан прив'язаний
# до нової анімації в словнику states_dict, якщо новий стан ідентичний до поточного - то
# перехід не відбудеться, або уникнути зайвого виклику функцій enter_state() та exit_state()
func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	last_anim = anim_name
	if current_state == null or not (current_state.anim_names.has(anim_name)):
		frame = 0
		enter_state(anim_name)


# Якщо анімація програлася до кінця, а looped_anim == true, то ця функція "перезайде" в поточну
# ноду анімації в дереві анімацій
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if current_state.looped_anim:
		anim_tree_state_machine.travel(anim_tree_state_machine.get_current_node())
