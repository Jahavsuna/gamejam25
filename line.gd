extends Node2D

const MIN_X = -100
const MAX_X = 740 # 640 + 100
const VISION_ANGLE_RAD: float = 15 * 3.14 / 180

@export var outer_width: int = 110
@export var edge_width: int = 20
@export var road_width: int = 380

@export var outer_color: Color
@export var edge_color: Color
@export var road_color: Color

@export var x_offset: float = 0.0
@export var y_offset: float = 0.0
@export var line_width: int = GameGlobals.LINE_WIDTH

func _ready() -> void:
	queue_redraw()

func _config_colors(line_accumulator) -> void:
	edge_color = Color.WHITE_SMOKE
	road_color = Color.BLACK
	if line_accumulator / GameGlobals.LINE_COLOR_SWICTH % 2 == 0:
		outer_color = Color.DARK_SLATE_GRAY
	else:
		outer_color = Color.SLATE_GRAY

func _config_sizes(line_accumulator) -> void:
	var length_change = tan(VISION_ANGLE_RAD) * line_accumulator
	outer_width += length_change
	road_width -= 2 * length_change

func configure_parameters(line_accumulator) -> void:
	# TODO: add texture instead of manual lines
	_config_colors(line_accumulator)
	_config_sizes(line_accumulator)

func _draw() -> void:
	var ttl_len = 2 * outer_width + 2 * edge_width + road_width
	if ttl_len - 640 > 1:
		print("Warning: bade line width: " + str(ttl_len))
	if outer_color == null or edge_color == null or road_color == null:
		print("ERROR: Line has no defined colors.")
	var outer_start = Vector2(MIN_X, y_offset)
	var left_outer_end = Vector2(x_offset + outer_width, y_offset)
	var left_edge_end = Vector2(left_outer_end.x + edge_width, y_offset)
	var road_end = Vector2(left_edge_end.x + road_width, y_offset)
	var right_edge_end = Vector2(road_end.x + edge_width, y_offset)
	var right_outer_end = Vector2(MAX_X, y_offset)
	draw_line(outer_start, left_outer_end, outer_color, line_width)
	draw_line(left_outer_end, left_edge_end, edge_color, line_width)
	draw_line(left_edge_end, road_end, road_color, line_width)
	draw_line(road_end, right_edge_end, edge_color, line_width)
	draw_line(right_edge_end, right_outer_end, outer_color, line_width)
