extends Control

@export var minimal_button_size = Vector2(50, 50)


func _ready():
	pass


func _on_load_level(id: int):
	SceneManager.load_level(id)
