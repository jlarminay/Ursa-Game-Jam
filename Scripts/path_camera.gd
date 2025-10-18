extends Camera2D

# Cinematic camera that follows a curved path, then smoothly transitions to the player camera

@export var camera_path: Path2D
@export var player: CharacterBody2D

# Progress tracking
var path_duration: float = 5.0 # Time to complete the path
var zoom_duration: float = 2.0 # Time to transition zoom to player camera
var progress: float = 0.0
var zoom_progress: float = 0.0
var is_zooming: bool = false
var level_started: bool = false
var initial_zoom: Vector2 # Starting zoom level for smooth transition

signal path_complete

func _ready() -> void:
  # Disable player movement during cinematic
  Game.can_player_move = false
  Game.can_sonic_move = false

  if camera_path:
    camera_path.visible = false
    fix_final_point() # Align path endpoint with player camera position
    # Start camera at beginning of path
    var start_local = camera_path.curve.get_point_position(0)
    global_position = camera_path.to_global(start_local)

  # Enable this camera and disable player camera
  enabled = true
  if player and player.get_player_camera():
    player.get_player_camera().enabled = false

func fix_final_point() -> void:
  # Automatically align the path's endpoint with the player camera position
  # This ensures a smooth transition from path camera to player camera
  if not player or not player.get_player_camera():
    return

  var curve = camera_path.curve
  var final_index = curve.get_point_count() - 1
  var player_camera = player.get_player_camera()
  var local_pos = camera_path.to_local(player_camera.global_position)
  curve.set_point_position(final_index, local_pos)

func _process(delta: float) -> void:
  if not camera_path:
    return

  if is_zooming:
    # Step 2: Zoom transition to match player camera
    zoom_progress += delta / zoom_duration
    zoom_progress = clamp(zoom_progress, 0.0, 1.0)

    # Smoothly interpolate zoom from initial to target
    if player and player.get_player_camera():
      var player_camera = player.get_player_camera()
      var target_zoom = player_camera.zoom
      zoom = initial_zoom.lerp(target_zoom, zoom_progress)

    # Complete the cinematic sequence
    if zoom_progress >= 1.0:
      switch_to_player_camera()
  else:
    # Step 1: Follow the curved path
    progress += delta / path_duration
    progress = clamp(progress, 0.0, 1.0)

    # Sample position along the curved path
    var path_length = camera_path.curve.get_baked_length()
    var local_position = camera_path.curve.sample_baked(progress * path_length)
    global_position = camera_path.to_global(local_position)

    # Transition to zoom phase when path is complete
    if progress >= 1.0 and not level_started:
      initial_zoom = zoom # Store current zoom for smooth transition
      is_zooming = true
      level_started = true
      Game.start_level() # Begin game countdown

func switch_to_player_camera() -> void:
  # Enable the player camera and clean up this cinematic camera
  if player and player.get_player_camera():
    var player_camera = player.get_player_camera()
    player_camera.enabled = true

  path_complete.emit()
  queue_free() # Remove this camera from the scene
