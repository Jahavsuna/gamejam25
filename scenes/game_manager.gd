extends Node2D
enum GameState {INIT, TITLE, PLAY, DEFEAT, VICTORY}

var state: GameState = GameState.INIT

func _ready() -> void:
	state = GameState.TITLE
	_apply_title() # I think game manager only spawns after we leave the title screen but whatever
	print("GameManager ready, state=" + str(state))

func _apply_defeat() -> void:
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _apply_victory() -> void:
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func _apply_title() -> void:
	pass

func _process(_delta: float) -> void:
	# Check whether the monster caught the player
	var monster_coordinate = GameGlobals.get_monster_track_coordinate()
	var player_coordinate = GameGlobals.get_player_track_coordinate()
	var track_end = GameGlobals.get_track_end_coordinate()
	if monster_coordinate >= player_coordinate:
		state = GameState.DEFEAT
		print("Player caught! state=" + str(state))
		_apply_defeat()
	
	# The player also loses if they are dragged off-screen
	var player_position = GameGlobals.get_player_screen_position()
	if player_position.y > GameGlobals.screen_height - 120: # TODO offset by player size somehow
		state = GameState.DEFEAT
		print("Player dragged off-screen! state=" + str(state))
		_apply_defeat()
	
	# Check whether the player reached the track end
	if player_coordinate >= track_end:
		state = GameState.VICTORY
		print("Player reached end! state=" + str(state))
		_apply_victory()
	
	#print("Monster distance: "+str(player_coordinate - monster_coordinate))
