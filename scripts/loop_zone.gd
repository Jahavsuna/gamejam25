extends Area2D
class_name loop_zone
var loop_to_segment:int = 0

@export var target_coordinate: int = 0:
	set(value):
		target_coordinate = value

@export var zone_dimensions: Vector2 = Vector2(0, 0):
	set(value):
		zone_dimensions = value
		if is_node_ready():
			_update_zone_collision()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_zone_collision()

func _update_zone_collision() -> void:
	pass
	
	
