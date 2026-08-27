extends Node2D

const NUMBERS := [1, 2, 3, 4, 5, 6]
const MAX_NUMBER = 7

signal clicked

@export var corrupt := false
@export var corrupt_chance := 1.0
@export var move_distance := 20.0
@export var border := Rect2(-285.0, -135.0, 570.0, 225.0)

var last_numbers = [0, 0, 0]
var available_numbers := NUMBERS

@onready var sides = [
	$Control/Side,
	$Control/Side2,
	$Control/Side3,
]


func _ready():
	_recalculate_sides()
	for side in sides:
		side.open()


func move(direction: Vector2):
	for side in sides:
		side.close()
	await get_tree().create_timer(0.2).timeout

	var target_position = global_position + move_distance * direction
	if not border.has_point(target_position):
		target_position = global_position - move_distance * direction
	var tween = self.create_tween()
	(
		tween
		. tween_property(self, "global_position", target_position, 0.5)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	_recalculate_sides()

	for side in sides:
		side.open()
	await get_tree().create_timer(0.2).timeout


func _recalculate_sides():
	var is_corrupt := corrupt and (randf() < corrupt_chance)
	available_numbers = NUMBERS.duplicate()

	var side_numbers = [0, 0, 0]
	if is_corrupt:
		side_numbers[0] = _pop_random()
		side_numbers[1] = _pop_random_and_erase_corrupt()
		side_numbers[2] = _corrupt_number(side_numbers[0])
	else:
		side_numbers[0] = _pop_random_and_erase_corrupt()
		side_numbers[1] = _pop_random_and_erase_corrupt()
		side_numbers[2] = _pop_random_and_erase_corrupt()

	sides[0].set_number(side_numbers[0])
	sides[1].set_number(side_numbers[1])
	sides[2].set_number(side_numbers[2])


func _pop_random() -> int:
	var number = available_numbers.pick_random()
	available_numbers.erase(number)
	return number


func _pop_random_and_erase_corrupt() -> int:
	var number = _pop_random()
	available_numbers.erase(_corrupt_number(number))
	return number


func _corrupt_number(number: int) -> int:
	return MAX_NUMBER - number
