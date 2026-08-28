extends Node

@onready var levels = {
	1: preload("res://game/levels/level_01.tscn"),
	2: preload("res://game/levels/level_02.tscn"),
	3: preload("res://game/levels/level_03.tscn"),
	4: preload("res://game/levels/level_04.tscn"),
	5: preload("res://game/levels/level_05.tscn"),
	10: preload("res://game/levels/level_10.tscn")
}

@onready var shell_texture = preload("res://assets/placeholders/shell.png")
