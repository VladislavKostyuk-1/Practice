extends Area2D

# Ця сцена відповідає за те щоб наносити пошкодження до носіїв сцени типу Hitbox при колізії з нею.
# !!!!!! Для того щоб змінити форму хартбоксу, спочатку треба увімкнути в цьому ноді опцію
# "Editable children", потім виділити ноду CollisionShape2D, і в інспекторі зробити ресурс Shape
# унікальним, інакше зміни хартбоксу в окремій сцені відразяться на хартбоксі у цій сцені.

signal damage_dealt

@export var Stats: AttackInfo

# Масив, що зберігає у собі всі цілі що отримали пошкодження зо поточну атаку. Необхідний для того,
# щоб одна й таж ціль отримала пошкодження не більше одного разу за атаку
var recorded_targets: Array


func set_is_active(value: bool, clear_hit_targets: bool = true):
	$CollisionShape2D.set_deferred("disabled", !value)
	
	if clear_hit_targets:
		clear_targets()
	
	if value == true:
		for area in get_overlapping_areas():
			_on_area_entered(area)

# Очищує масив recorded_targets
func clear_targets():
	recorded_targets.clear()


# При колізією з хітбоксом, додає його носія до масиву recorded_targets, якщо він там відсутній,
# а також завдає йому пошкодження
func _on_area_entered(area: Area2D) -> void:
	if not recorded_targets.has(area.owner) and abs(owner.position_z - area.owner.position_z) <= 20:
		if area.owner != owner:
			Stats.attacker = owner
			if owner is Player or Stats.can_friendly_fire or owner.target == area.owner:
				recorded_targets.append(area.owner)
				area.take_damage(Stats)
				damage_dealt.emit()
