extends Node2D

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer

func _ready() -> void:
  music_player.play()
