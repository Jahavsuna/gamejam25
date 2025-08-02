extends Node2D

func _calc_position_offset(delta: float) -> Vector2:
	var track_speed = GameGlobals.track_speed
	var y_offset = track_speed * delta
	var projective_x_offset = y_offset * tan(GameGlobals.VISION_ANGLE_RAD)
	
	
	#TODO: objects to the left of center of road, not screen
	# Objects to the left of the screen center move left, objects to the right move right.
	var approximate_line = GameGlobals.get_line_by_y(self.position.y)
	if self.position.x < approximate_line.get_center():
		projective_x_offset *= -1
	
	# x_offset is modified by the current segment's dx
	var curr_dx = GameGlobals.get_current_dx()
	var curr_road_fraction = GameGlobals.get_road_fraction(self.position.y)
	var next_road_fraction = GameGlobals.get_road_fraction(self.position.y + y_offset)
	var passed_lines = curr_road_fraction - next_road_fraction
	var offset_from_dx = -curr_dx * passed_lines
	
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
