extends AudioStreamPlayer2D

@export var starting_sound: AudioStream

func play_starting_sound():
	if starting_sound:
		stream = starting_sound
		play()
