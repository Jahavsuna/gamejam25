extends AudioStreamPlayer


func _process(delta: float) -> void:
	var player = get_parent()
	if player.direction.y < 0:
		if  !self.playing:
			self.play()
	else:
		self.stop()
