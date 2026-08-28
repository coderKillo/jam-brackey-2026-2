class_name Building
extends Button

@export var id := 0
@export var required_munition := 3
@export var dices := 2
@export var building_name := "Building"
@export_multiline var description := "Building"

@onready var _toolbox: Control = $ToolTip
@onready var _toolbox_label: RichTextLabel = $ToolTip/MarginContainer/RichTextLabel
@onready var _requirement: Control = $Requirement

@onready var _texture: TextureRect = $TextureRect

var _locked := false
var _cleared := false


func _ready():
	Events.munition_changed.connect(_on_munition_changed)
	Events.building_cleared.connect(_on_building_cleared)
	pressed.connect(func(): Events.building_selected.emit(id))
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

	_toolbox.hide()
	_requirement.hide()

	_set_toolbox_text()
	_set_toolbox_position()
	_set_requirement()
	_on_munition_changed()
	_on_building_cleared()


func _on_munition_changed():
	if _cleared:
		return
	var munition = GameState.get_munition()
	_locked = munition < required_munition
	_texture.material.set_shader_parameter("locked", _locked)
	disabled = _locked


func _on_building_cleared():
	if GameState.is_building_cleared(id):
		_cleared = true
		_texture.material.set_shader_parameter("cleared", _locked)
		disabled = true


func _mouse_entered():
	_texture.material.set_shader_parameter("outline", true)
	_texture.scale = Vector2(1.2, 1.2)
	if _cleared:
		return

	if _locked:
		_show_requirement()
		_toolbox.hide()
	else:
		_show_toolbox()
		_requirement.hide()


func _mouse_exited():
	_texture.material.set_shader_parameter("outline", false)
	_texture.scale = Vector2(1.0, 1.0)
	_toolbox.hide()
	_requirement.hide()


func _set_toolbox_text():
	_toolbox_label.text = _toolbox_label.text.format(
		{"title": building_name, "dice": dices, "description": description}
	)


func _set_toolbox_position():
	var direction = (global_position - Global.SCREEN_SIZE_HALF).sign()
	if direction.x == 1:
		_toolbox.offset_transform_position.x = -200.0
	if direction.y == 1:
		_toolbox.offset_transform_position.y = -100.0


func _set_requirement():
	var container = _requirement.get_node("HBoxContainer")
	for i in range(required_munition):
		var tex_rect := TextureRect.new()
		tex_rect.texture = GlobalResources.shell_texture
		container.add_child(tex_rect)


func _show_requirement():
	_requirement.show()
	var tween = get_tree().create_tween()
	(
		tween
		. tween_property(_requirement, "offset_transform_position:y", 0.0, 0.2)
		. from(-100.0)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_ELASTIC)
	)


func _show_toolbox():
	_toolbox.show()
	var tween = get_tree().create_tween()
	(
		tween
		. tween_property(_toolbox, "offset_transform_scale", Vector2.ONE, 0.2)
		. from(Vector2.ZERO)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_ELASTIC)
	)
