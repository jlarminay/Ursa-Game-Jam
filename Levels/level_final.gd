extends Node2D

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@export var sonic: Node2D
@export var player: CharacterBody2D
@export var player_path: Line2D
@export var sonic_path: Line2D
@export var hurray_sound: AudioStream
var final_cut_scene: bool = false

func _ready() -> void:
  music_player.play()
  Game.can_sonic_move = false
  sonic.global_position = Vector2(-1000, -1000) # hide sonic offscreen

func _on_cut_scene_trigger_body_entered(body: Node2D) -> void:
  if body.name == 'Player' and not final_cut_scene:
    final_cut_scene = true
    Game.can_player_move = false

    # Start the animated cutscene sequence
    start_final_cutscene()

func start_final_cutscene() -> void:
  # move player along path to end
  # once there, move sonic to start of path and move along
  # once there, start dialogue and end level
  # Set player to run right during movement
  var player_tween = create_tween()
  var path_length = player_path.get_point_count()
  for i in range(1, path_length):
    var target_position = player_path.get_point_position(i)
    player_tween.tween_property(player, "position", target_position, 0.5)
  player_tween.set_ease(Tween.EASE_IN_OUT)
  await player_tween.finished

  # When finished, set to idle facing down
  player.last_direction = "Down"
  player.current_action = "Idle"

  # move sonic
  sonic.global_position = sonic_path.get_point_position(0)
  Game.can_sonic_move = true
  #sonic will move by himself, so wait until he reaches the end
  while sonic.position.distance_to(sonic_path.get_point_position(sonic_path.get_point_count() - 1)) > 1.0:
    await get_tree().process_frame

    # display some text
  await TextBox.show_text([
    "Well done! You made it to the finish line!",
    "I guess I underestimated you.",
    "Your the king now!",
  ])
  player.show_crown()
  AudioController.play_sound(hurray_sound)
  await TextBox.show_text([
    "Hip Hip Hooray! Hip Hip Hooray! Hip Hip Hooray!",
  ])
  Game.can_player_move = true

  # wait 6 seconds
  await get_tree().create_timer(6.0).timeout

  # go to credits
  get_tree().change_scene_to_file("res://Levels/Credits.tscn")
