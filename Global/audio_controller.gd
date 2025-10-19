extends Node2D

func _ready():
  pass

func play_sound(sound: AudioStream, volume: float = 0.0, looping: bool = false) -> AudioStreamPlayer2D:
  if not sound:
    return null

  var player = AudioStreamPlayer2D.new()
  add_child(player)
  player.stream = sound
  player.volume_db = volume

  # Handle looping for music
  if looping and sound is AudioStreamOggVorbis:
    sound.loop = true
  elif looping and sound is AudioStreamMP3:
    sound.loop = true

  player.play()

  # Only auto-delete if not looping
  if not looping:
    player.finished.connect(player.queue_free)

  return player

func stop_all_sounds():
  for child in get_children():
    if child is AudioStreamPlayer2D:
      child.stop()
      child.queue_free()
