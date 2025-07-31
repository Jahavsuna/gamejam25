extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var player = get_parent()
	move_and_collide(player.direction*delta)
