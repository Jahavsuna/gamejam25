extends Node2D

var safe_zone:int = 1
var loop_to_segment:int = 0

func _process(delta: float) -> void:
	var speed = GameGlobals.track_speed	
	self.position.y += speed * delta
	if self.position.y < GameGlobals.top_track_y: return
	self.visible = true

	self.scale += (Vector2(GameGlobals.scale_rate, GameGlobals.scale_rate)*delta/2)
	if GameGlobals.player_node.position.y < self.position.y:
		self.z_index = GameGlobals.player_node.z_index -1
