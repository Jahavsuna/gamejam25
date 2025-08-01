extends Control

const KEY_LOCK_TIME_SEC: float = 1.0
var can_receive_input: bool = false

func _ready():
	can_receive_input = false
	print("Victory screen ready, waiting for lock time")
	await get_tree().create_timer(KEY_LOCK_TIME_SEC).timeout
	$PlayAgainText.visible = true
	can_receive_input = true

func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _input(event) -> void:
	if can_receive_input:
		if event is InputEventKey:
			if event.pressed:
				start_game()
