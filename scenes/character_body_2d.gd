extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var player = get_parent()
	var collided = move_and_collide(player.direction*delta)
	var audioplayer = self.get_child(0)
	if collided:
		if  !audioplayer.playing:
			audioplayer.play()
