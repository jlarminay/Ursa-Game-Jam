extends Area2D


@export var line: Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_point = line.get_point_count()
	global_position = line.get_point_position(last_point - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	Game.level_success = true
	Game.can_player_move = false
	Game.can_sonic_move = false
