extends Node2D

@onready var level: PackedScene = preload("res://prototype/scenes/level.tscn")

var ammo: int = 0:
	set(value):
		ammo = value
		$CanvasLayer/Gui/AmmoLabel.text = str(ammo)

var people: int = 0:
	set(value):
		print("Lost %s people" % (people - value))
		people = value
		$CanvasLayer/Gui/PeopleLabel.text = str(people)

var time: float = 0.0:
	set(value):
		time = value
		$CanvasLayer/Gui/TimerLabel.text = "%10.2f" % time

var _level: Node2D


func _ready():
	people = 15
	ammo = 0
	($Town/Level as Button).pressed.connect(_load_level)
	($Town/AmmoButton as Button).pressed.connect(_buy_ammo)


func _process(delta):
	if is_instance_valid(_level):
		time -= delta
		if time <= 0:
			time = 1.0
			_level.end_level()


func _load_level():
	if ammo < 3:
		print("require 3 ammo")
		return
	time = 30.0
	_level = level.instantiate()
	_level.ammo = ammo
	_level.level_end.connect(_level_finished)
	$Town.hide()
	add_child(_level)


func _buy_ammo():
	people -= 1
	if people <= 0:
		print("LOSE")
		return
	ammo += 1


func _level_finished(corrupted: int):
	_level.queue_free()
	$Town.show()

	people -= corrupted
	if people <= 0:
		print("LOSE")

	if corrupted <= 0:
		print("WIN")


func _input(event):
	if event is not InputEventMouseButton:
		return
	if not event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		return
	if not event.pressed:
		return
	_shoot()


func _shoot():
	if not is_instance_valid(_level):
		return
	if ammo <= 0:
		print("no ammo")
		return
	ammo -= 1
	_level.shoot()
