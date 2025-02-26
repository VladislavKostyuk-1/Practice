extends Area2D

# Ця сцена відповідає за те щоб її носій міг отримувати пощкодження при колізії
# зі сценою типу HurtBox
# !!!!!! Для того щоб змінити форму хітбоксу, спочатку треба увімкнути в цьому ноді опцію
# "Editable children", потім виділити ноду CollisionShape2D, і в інспекторі зробити ресурс Shape
# унікальним, інакше зміни хітбоксу в окремій сцені відразяться на хітбоксі у цій сцені.

@export var health_component: ComponentHealth ## Компонент здоров'я носія хітбоксу


func set_is_active(value: bool):
	$CollisionShape2D.set_deferred("disabled", !value)


func take_damage(Stats: AttackInfo):
	owner.modulate = Color(1, 1, 1)
	
	health_component.take_damage(Stats.get_current("damage"))
	apply_knockback(Stats)
	
	owner.modulate = Color(1, 0.58, 0.503)
	await  get_tree().create_timer(0.1).timeout
	owner.modulate = Color(1, 1, 1)


func apply_knockback(Stats: AttackInfo):
	var center = Stats.attacker.global_position
	
	var direction = (owner.global_position - center).normalized()
	
	owner.velocity += direction * Stats.knockback
