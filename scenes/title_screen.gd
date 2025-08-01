extends Control

func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			start_game()
