extends Node2D

var player_v:float = 50
var track_coordinate: int = 0
var track_speed: int = 2
var direction:Vector2 = Vector2.ZERO

func _ready() -> void:
	GameGlobals.register_player(self)
	print("Player initialized")

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta


func _process(delta):
	direction = Vector2.ZERO
	# Detect continuous movement input using UI actions (configured in Project Settings -> Input Map)
	if Input.is_action_pressed("ui_left"):
		self.direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		self.direction.x += 1
	
	self.direction.y += track_speed
	if GameGlobals.DEBUG:
		if Input.is_action_pressed("ui_up"):
			self.direction.y -= track_speed + 1
		if Input.is_action_pressed("ui_down"):
			self.direction.y += 1
			
