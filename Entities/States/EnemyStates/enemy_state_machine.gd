extends StateMachine

# Скрипт, похідний від класу StateMachine. Контролює параметри дерева анімацій,
# ексклюзивні для ворогів.
# Поточні параметри:
#--------------------
# has_target
# has_no_target
#--------------------

func _on_ready() -> void:
	AnimTree.set("parameters/conditions/has_target", false)
	AnimTree.set("parameters/conditions/has_no_target", true)
	
	owner.connect("target_acquired", _on_target_acquired)
	owner.connect("target_lost", _on_target_lost)


func _on_target_acquired(_target):
	AnimTree.set("parameters/conditions/has_target", true)
	AnimTree.set("parameters/conditions/has_no_target", false)


func _on_target_lost():
	AnimTree.set("parameters/conditions/has_target", false)
	AnimTree.set("parameters/conditions/has_no_target", true)
