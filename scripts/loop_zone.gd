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

func _update_zone_collision() -> void:
	pass
	
func _process(delta: float) -> void:
	var speed = GameGlobals.track_speed	
	self.position.y += speed * delta
	if self.position.y < GameGlobals.top_track_y: return
	self.visible = true

	self.scale += (Vector2(GameGlobals.scale_rate, GameGlobals.scale_rate)*delta/2)
	if GameGlobals.player_node.position.y < self.position.y:
		self.z_index = GameGlobals.player_node.z_index -1
		#self.modulate.a = 0.3
	
