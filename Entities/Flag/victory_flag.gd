extends Area2D

@export var line: Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var last_point = line.get_point_count()
  global_position = line.get_point_position(last_point - 1)

  # call start level
  Game.can_player_move = false
  Game.can_sonic_move = false
  # Game.start_level()

func _on_body_entered(body: Node2D) -> void:
  if (body.name == 'Player'):
    Game.level_success = true
