class_name SoundController
extends Node

enum { DEATH_HUMAN, DEATH_DICE, SHOOT, SLIDE, SELECTED }

@onready var sounds = {
	DEATH_HUMAN: $DeathHuman,
	DEATH_DICE: $DeathDice,
	SHOOT: $Shoot,
	SLIDE: $Slide,
	SELECTED: $Selected
}


func _ready():
	Events.play_sound.connect(_on_play_sound)


func _on_play_sound(sound: int):
	if sound not in sounds:
		printerr("sound: '%s' not found" % sound)
		return
	(sounds[sound] as AudioStreamPlayer).pitch_scale = randf_range(0.8, 1.2)
	(sounds[sound] as AudioStreamPlayer).play()
