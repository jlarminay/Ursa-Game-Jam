extends Node2D

@export var starting_sound: AudioStream
@export var intro_music: AudioStream
@export var background_music: AudioStream

var music_player: AudioStreamPlayer2D

func _ready():
	music_player = AudioStreamPlayer2D.new()
	add_child(music_player)

func play_sound(sound: AudioStream):
	if not sound:
		return

	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.stream = sound
	player.play()
	player.finished.connect(player.queue_free)

func play_music(music: AudioStream):
	if not music:
		return

	music_player.stream = music
	music_player.play()

func stop_music():
	music_player.stop()

# Convenience functions
func play_starting_sound():
	play_sound(starting_sound)

func play_intro_music():
	play_music(intro_music)

func play_background_music():
	play_music(background_music)
