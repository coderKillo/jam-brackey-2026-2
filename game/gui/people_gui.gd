extends Control

@onready var number_label: Label = $Label


func _ready():
	Events.people_changed.connect(_on_people_changed)
	_on_people_changed()


func _on_people_changed():
	number_label.text = str(GameState.get_people())
