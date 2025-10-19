extends Node2D

@onready var tree_obstacle: StaticBody2D = $TreeObstacle
@onready var sonic: Node2D = $Sonic
var tree_cut_scene: bool = false

func _ready() -> void:
  start_countdown_cutscene()

func _on_tree_trigger_body_entered(body: Node2D) -> void:
  if body.name == 'Player' and not tree_cut_scene:
    tree_cut_scene = true
    Game.can_player_move = false

    # Start the animated cutscene sequence
    start_tree_cutscene()

func start_countdown_cutscene() -> void:
  # start some text then go
  Game.can_player_move = false
  Game.can_sonic_move = false
  await TextBox.show_text([
    "Welcome to the annual Race!",
    "Get to the finish line as fast as you can!",
    "No funny business!",
    "Ready? Set... GO!"
  ])
  Game.start_level()


func start_tree_cutscene() -> void:
  # Create tween for tree movement
  var tree_tween = create_tween()
  tree_tween.parallel().tween_property(tree_obstacle, "position:y", tree_obstacle.position.y + 40, 1.0)
  tree_tween.parallel().tween_property(tree_obstacle, "rotation_degrees", 30, 1.0)
  tree_tween.set_ease(Tween.EASE_IN_OUT)

  # Wait for tree animation to complete
  await tree_tween.finished

  # display some text
  await TextBox.show_text([
    "Ha Ha! Good luck following me now!",
    "This is the fastest route and now your can't follow me!",
    "Thank god there is no shortcut through those trees over there",
    "HA HAHAHA!"
  ])

  # Move sonic north (animated)
  var sonic_tween = create_tween()
  sonic.last_direction = "Up"
  sonic_tween.tween_property(sonic, "position:y", sonic.position.y - 100, 1)
  sonic_tween.set_ease(Tween.EASE_IN_OUT)

  # Wait for sonic movement to complete
  await sonic_tween.finished

  # Delete sonic and wait for it to be fully removed
  sonic.queue_free()
  await sonic.tree_exited

  # Re-enable player movement
  Game.can_player_move = true
