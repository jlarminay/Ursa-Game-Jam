extends CharacterBody2D

@export var camera_path: Line2D
@export var SPEED: int = 300
@onready var camera: Camera2D = $Camera2D

var camera_at_player: bool = false
var camera_path_index: int = 1
var camera_velocity: Vector2 = Vector2.ZERO
var camera_speed: int = 300
var camera_initial_zoom: float = 1.0
var camera_target_zoom: float = 2.0
var zoom_speed: float = 1.0
var is_zooming: bool = false

func _ready() -> void:
  camera_path.visible = false
  # set initial camera position to flag position
  camera.global_position = camera_path.get_point_position(0)
  # set initial zoom
  camera.zoom = Vector2(camera_initial_zoom, camera_initial_zoom)

func _process(delta: float) -> void:
  camera_movement()
  camera_zoom(delta)

  var vector = Vector2(
    Input.get_action_strength("Right") - Input.get_action_strength("Left"),
    Input.get_action_strength("Down") - Input.get_action_strength("Up")
  ).normalized()

  if Game.can_player_move:
    velocity = vector * SPEED
    move_and_slide()

func camera_movement() -> void:
  if camera_at_player:
    return

  var target: Vector2 = camera_path.get_point_position(camera_path_index)
  # take target position and move towards it
  camera.global_position = camera.global_position.move_toward(target, camera_speed * get_process_delta_time())

  if camera.global_position.distance_to(target) == 0:
    camera_path_index += 1

  if camera_path_index >= camera_path.get_point_count():
    camera_at_player = true
    camera.position = Vector2.ZERO
    is_zooming = true
    Game.start_level()

func camera_zoom(delta: float) -> void:
  if not is_zooming:
    return

  # smoothly interpolate zoom from current to target
  var current_zoom = camera.zoom.x
  var new_zoom = move_toward(current_zoom, camera_target_zoom, zoom_speed * delta)
  camera.zoom = Vector2(new_zoom, new_zoom)

  # stop zooming when we reach the target
  if abs(camera.zoom.x - camera_target_zoom) < 0.01:
    camera.zoom = Vector2(camera_target_zoom, camera_target_zoom)
    is_zooming = false
