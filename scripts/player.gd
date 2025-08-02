extends Node2D
class_name PlayerNode

const STANDARD_TRACK_V: float = 100
const SLOW_TRACK_V: float = 60

var player_v: float = 60
var player_track_v: float = STANDARD_TRACK_V
var track_coordinate: float = 0
var direction:Vector2 = Vector2.ZERO

func _ready() -> void:
	GameGlobals.register_player(self)
	print("Player initialized")

func _physics_process(delta: float) -> void:
	track_coordinate += GameGlobals.get_player_track_velocity() * delta

# Oh no we are now paying the price for not knowing Godot in the beginning
func _get_player_feet_position() -> Vector2: 
	var original_position = self.position
	var character_body_position = self.get_child(0).position
	var scaled_body_position = self.scale * character_body_position
	var player_shape = self.get_child(0).get_child(1).get_shape()
	var scaled_shape = player_shape.size * self.scale
	var top_left_corner_pos = original_position + scaled_body_position
	var collider_offset = Vector2(0,0)
	var player_feet = top_left_corner_pos + collider_offset
	return player_feet

func _process(_delta: float):
	# Check if player is on road sides
	var player_feet = _get_player_feet_position()
	var approximate_line = GameGlobals.get_line_by_y(player_feet.y)
	var player_left_of_track:  bool = player_feet.x < approximate_line.get_left_outer_end()
	var player_right_of_track: bool = player_feet.x > approximate_line.get_right_outer_start()
	if player_left_of_track or player_right_of_track:
		player_track_v = SLOW_TRACK_V
	else:
		player_track_v = STANDARD_TRACK_V
	
	direction = Vector2.ZERO
	# Detect continuous movement input using UI actions (configured in Project Settings -> Input Map)
	if Input.is_action_pressed("ui_left"):
		self.direction.x -= player_v
	if Input.is_action_pressed("ui_right"):
		self.direction.x += player_v
	
	self.direction.y += GameGlobals.get_player_track_velocity()
	if GameGlobals.DEBUG:
		if Input.is_action_pressed("ui_up"):
			self.direction.y -= GameGlobals.get_player_track_velocity() + player_v
		if Input.is_action_pressed("ui_down"):
			self.direction.y += player_v
			
