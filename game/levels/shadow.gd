class_name Shadow
extends Node2D

@export var radius := 60.0

@onready var center: Control = $CanvasGroup/ColorRect/Center


func has_point(point: Vector2):
	return center.global_position.distance_to(point) <= radius


func _process(_delta):
	center.global_position = get_global_mouse_position()
