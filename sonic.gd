extends Node2D

@export var line: Line2D
var index: int = 1

const SPEED = 250.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.visible = false
	global_position = line.get_point_position(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Game.can_sonic_move:
		return

	var target: Vector2 = line.get_point_position(index)
	# take target position and move towards it
	global_position = global_position.move_toward(target, SPEED * delta)

	if global_position.distance_to(target) == 0:
		index += 1
	
	if index >= line.get_point_count():
		index = line.get_point_count() - 1
		Game.game_over = true
		Game.can_player_move = false
		Game.can_sonic_move = false
