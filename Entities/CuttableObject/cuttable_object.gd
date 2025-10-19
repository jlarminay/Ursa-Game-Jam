extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_area_2d_body_entered(body: Node2D) -> void:
  if body.name == 'Player' and body.held_item == 'Axe':
    Game.can_player_move = false

    # start cutting animation
    await body.play_cutting_animation()

    Game.can_player_move = true
    body.remove_item()

    # destroy this object after a short delay
    queue_free()
