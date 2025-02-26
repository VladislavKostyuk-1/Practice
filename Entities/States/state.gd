extends Node

class_name State

# Клас стану. Стани відповідають за поведінку сутностей, як грацець, вороги і тд.
# Стани контролюються машиною станів.

enum LOOK_DIRECTION{
	MOUSE, ## Погляд залежить від положення курсору миші
	MOVEMENT, ## Погляд залежить від клавіш управління
	VELOCITY, ## Погляд залежить від напряму пересування
	TARGET, ## Погляд залежить від положення цілі
}

@export_group("Base")
@export var state_name:String = "State" ## Назва стану

@export_group("Animation")
@export var anim_names: Array[String] ## Назви анімацій, програвання яких активує цей стан
@export var looped_anim: bool = true ## Чи є анимація циклічною
@export var look_direction: LOOK_DIRECTION ## Те, від чого залежатиме напрям погляду сутності
@export var block_direction_change: bool = false ## Чи буде заблокованою зміна напряму погляду під час цього стану

@export_group("Behaviour")
@export var can_move: bool = true ## Чи може гравцеь рухатись під час цього стану
@export var rotate_hurtbox_on_start: bool = false ## Чи буде хартбокс повернутий у напрям погляду при вході в стан
@export var lock_hitbox_rotation_by_90: bool = true ## Залочення повороту хартбокса на 90 градусів

# Чи активний наразі цей стан
var is_active: bool = false

func enter_state():
	is_active = true
	_on_state_entered()


func exit_state():
	is_active = false
	_on_state_exited()


# Функції, що викликаються при вході та виході зі стану. Їх тіло необхідно заповнити
# самостійно в похідному від цього класу скрипті
func _on_state_entered():
	pass


func _on_state_exited():
	pass
