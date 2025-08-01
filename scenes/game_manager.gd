extends Node2D
enum GameState {INIT, TITLE, PLAY, DEFEAT, VICTORY}

var state: GameState = GameState.INIT

func _ready() -> void:
	state = GameState.TITLE
	_apply_title()
	print("GameManager ready, state=" + str(state))

func _apply_defeat() -> void:
	pass

func _apply_victory() -> void:
	pass

func _apply_title() -> void:
	pass

func _process(delta: float) -> void:
	# Check whether the monster caught the player
	var monster_coordinate = GameGlobals.get_monster_track_coordinate()
	var player_coordinate = GameGlobals.get_player_track_coordinate()
	var track_end = GameGlobals.get_track_end_coordinate()
	if monster_coordinate >= player_coordinate:
		state = GameState.DEFEAT
		print("Player caught! state=" + str(state))
		_apply_defeat()
	
	# Check whether the player reached the track end
	if player_coordinate >= track_end:
		state = GameState.VICTORY
		print("Player reached end! state=" + str(state))
