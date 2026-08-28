extends Control

@export var texture: Texture2D

@onready var container: Control = $HBoxContainer


func _ready():
	Events.munition_changed.connect(_on_munition_changed)
	_on_munition_changed()


func _on_munition_changed():
	var munition = GameState.get_munition()
	var munition_icon_count = container.get_child_count()

	if munition > munition_icon_count:
		for i in range(munition - munition_icon_count):
			var tex_rect := TextureRect.new()
			tex_rect.texture = GlobalResources.shell_texture
			container.add_child(tex_rect)
	elif munition_icon_count > munition:
		for i in range(munition_icon_count - munition):
			container.get_child(i).queue_free()
