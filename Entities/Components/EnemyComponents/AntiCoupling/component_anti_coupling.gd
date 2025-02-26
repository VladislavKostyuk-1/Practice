extends Component

@export var zone_radius: float = 40
@export var power: float = 20
@export var affected_states: Array[String]

var new_velocity: Vector2

@onready var zone = $Area2D



func _ready() -> void:
	owner.add_to_group("AntiCoupling")
	$Area2D/CollisionShape2D.shape.radius = zone_radius

func _physics_process(delta: float) -> void:
	if zone.get_overlapping_bodies() != null:
		for body in zone.get_overlapping_bodies():
			if body.is_in_group("AntiCoupling") and body.StMachine.current_state and affected_states.has(body.StMachine.current_state.state_name):
				new_velocity = body.velocity + (body.global_position - owner.global_position).normalized() * power * delta
				
				if get_speed(new_velocity) < get_speed(body.velocity):
					body.velocity = new_velocity


func get_speed(vector: Vector2) -> float:
	return sqrt(vector.x * vector.x + vector.y * vector.y)
