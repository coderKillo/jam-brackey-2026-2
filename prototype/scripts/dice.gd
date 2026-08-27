extends Node3D

var _timer := 2.0
var _rotating := false
var _rotating_time := 0.2

@onready var pivot_point: Node3D = $Piviot
@onready var model: Node3D = $Piviot/Model


func _ready():
	pass  # Replace with function body.


func _process(delta):
	if _rotating:
		return

	_timer -= delta
	if _timer <= 0.0:
		_timer = 2.0
		_rotation()


func _rotation():
	pivot_point.global_position = global_position + (Vector3.RIGHT / 2.0) + (Vector3.DOWN / 2.0)
	model.global_position = global_position

	_rotating = true
	var tween = get_tree().create_tween()
	tween.tween_property(
		pivot_point, "rotation_degrees:z", pivot_point.rotation_degrees.z - 90.0, _rotating_time
	)
	await tween.finished

	global_position = model.global_position
	model.global_position = global_position

	_rotating = false
