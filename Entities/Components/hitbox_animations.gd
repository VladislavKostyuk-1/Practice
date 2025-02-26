extends AnimationPlayer

func _ready() -> void:
	$"../StateMachine".connect("state_changed", _on_state_changed)


func _on_animation_finished(_anim_name: StringName) -> void:
	play("RESET")


func _on_state_changed(_state):
	play("RESET")
