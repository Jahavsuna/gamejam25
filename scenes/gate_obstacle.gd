extends Node2D

func _calc_position_offset(delta: float) -> Vector2:
	# Get y-offset
	var track_speed = GameGlobals.get_player_track_velocity()
	var y_offset = track_speed * delta
	var projective_x_offset = y_offset * tan(GameGlobals.VISION_ANGLE_RAD)
	
	# Objects to the left of the screen center move left, objects to the right move right.
	var sprite: Sprite2D = $Sprite2D
	var object_bottom_y = self.position.y + sprite.get_rect().size.y
	var approximate_line = GameGlobals.get_line_by_y(object_bottom_y)
	var my_center_x = self.position.x + (sprite.get_rect().size.x / 2)
	if my_center_x < approximate_line.get_center():
		projective_x_offset *= -1
	
	# x_offset is modified by the current segment's dx
	var curr_dx = GameGlobals.get_current_dx()
	
	var curr_road_line = GameGlobals.get_line_by_y(self.position.y)
	var next_road_line = GameGlobals.get_line_by_y(self.position.y + y_offset)
	var offset_from_dx = next_road_line.x_offset - curr_road_line.x_offset
	
	# Return offset vector
	var offset_vec = Vector2(projective_x_offset + offset_from_dx, y_offset)
	return offset_vec

func _process(delta: float) -> void:
	var offset_vec = _calc_position_offset(delta)
	self.position += offset_vec
	if self.position.y < GameGlobals.horizon_y: return
	self.visible = true

	
	self.scale += (Vector2(GameGlobals.scale_rate, GameGlobals.scale_rate)*delta/2)
	if GameGlobals.player_node.position.y < self.position.y:
		self.z_index = GameGlobals.player_node.z_index -1
		
	
	if self.position.y > GameGlobals.screen_height + 50:
		self.queue_free()
