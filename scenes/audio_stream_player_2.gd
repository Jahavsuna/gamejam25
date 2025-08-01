extends AudioStreamPlayer


func _process(delta: float) -> void:
	var player = get_parent()
	if player.direction.x == 0 and player.direction.y >= 0 :
		self.stop()
	else:
		if  !self.playing:
			self.play()
			
