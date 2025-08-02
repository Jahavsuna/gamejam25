extends Node2D

var safe_zone:int = 1
var loop_to_segment:int = 0

func _process(delta: float) -> void:
	# Update position
	var speed = GameGlobals.get_player_track_velocity()
	self.position.y += speed * delta
	if self.position.y < GameGlobals.horizon_y: return
	self.visible = true

	self.scale += (Vector2(GameGlobals.scale_rate, GameGlobals.scale_rate)*delta/2)
	if GameGlobals.player_node.position.y < self.position.y:
		self.z_index = GameGlobals.player_node.z_index -1
		
		
	if self.position.y > GameGlobals.screen_height + 50:
		self.queue_free()
