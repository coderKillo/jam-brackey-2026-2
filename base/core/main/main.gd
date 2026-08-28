class_name Main
extends Control

signal skip_tutorial

@export var level_container: Node
@export var gui: Control

@onready var town: Town = $World/Town
@onready var tutorial: Control = $CanvasLayer/Gui/TutorialOverlay

var _level: Level


func _ready():
	SceneManager.main = self
	Events.building_selected.connect(_on_building_selected)
	Events.level_done.connect(_on_level_done)
	Events.people_changed.connect(_on_people_changed)
	Events.munition_changed.connect(_on_munition_changed)
	Events.building_cleared.connect(_on_building_cleared)
	_on_munition_changed()
	if GameState.is_new_game():
		_start_tutorial()


func _input(event: InputEvent):
	if event.is_action_pressed("skip"):
		skip_tutorial.emit()


func _on_building_selected(id: int):
	if id == Global.BLOODSMITH_ID:
		_sacrifice_people()
	else:
		_load_level(id)


func _sacrifice_people():
	if GameState.people <= 0:
		return

	GameState.munition += 1
	GameState.people -= 1
	Events.camera_shake.emit(0.3)


func _load_level(id):
	if not GlobalResources.levels.has(id):
		push_error("no level id: %s" % id)
		return

	_level = GlobalResources.levels[id].instantiate()
	_level.id = id
	level_container.add_child(_level)
	town.hide()


func _on_level_done(corrupted_dice: int):
	if not is_instance_valid(_level):
		return

	if corrupted_dice <= 0:
		GameState.set_building_cleared(_level.id)

	_level.queue_free()
	town.show()


func _on_people_changed():
	if GameState.people <= 0:
		Events.level_lose.emit()


func _on_munition_changed():
	$World/Town/BloodSmith/MunitionRebuy.visible = GameState.munition <= 0


func _on_building_cleared():
	if GameState.is_building_cleared(Global.TOWN_HALL_ID):
		Events.level_won.emit()


func _start_tutorial():
	tutorial.show()
	for child in tutorial.get_children():
		child.visible_ratio = 0.0
		child.show()
		var tween = get_tree().create_tween()
		tween.tween_property(child, "visible_ratio", 1.0, 2.0).from(0.0)
		tween.tween_await(skip_tutorial)
		await tween.finished
		child.hide()
	tutorial.hide()
