extends Area2D
class_name loop_zone

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
	body_entered.connect(_on_body_entered)

func _update_zone_collision() -> void:
	pass

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		# TODO: move the player coordinate, then get monster coordinate and update it accordingly.
		pass
