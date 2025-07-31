extends AnimatedSprite2D

func _process(delta: float) -> void:
	var player = get_parent().get_parent()

	if player.direction.x > 0:
		self.play("right")
	elif player.direction.x < 0:
		self.play("left")
	else:
		self.play("straight")
