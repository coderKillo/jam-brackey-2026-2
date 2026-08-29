class_name Dice
extends Area2D

@export var corrupt := false
@export var corrupt_chance := 1.0
@export var move_distance := 20.0

@onready var sides = [$Side1, $Side2, $Side3]

# LEFT, TOP, DOWN
var last_numbers = [0, 0, 0]
var available_numbers := Global.NUMBERS
var default_direction := Vector2(1, 1)


func _ready():
	default_direction = (global_position - Vector2(320, 180)).sign()
	recalculate_sides(false)


func move(direction: Vector2):
	var target_position = global_position + move_distance * direction
	if not Global.WORLD_BORDER.has_point(target_position):
		default_direction = -default_direction
		target_position = global_position - move_distance * direction
	var tween = self.create_tween()
	tween.set_parallel(true)
	(
		tween
		. tween_property(self, "global_position", target_position, 0.5)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	(
		tween
		. tween_property(self, "rotation_degrees", rotation_degrees + 120.0 * direction.x, 0.5)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	await tween.finished


func close():
	for side in sides:
		side.close()
	await get_tree().create_timer(0.2).timeout


func open():
	for side in sides:
		side.open()
	await get_tree().create_timer(0.2).timeout


func kill():
	queue_free()
	Events.play_sound.emit(SoundController.DEATH_DICE)
	Events.dice_killed.emit(self)


func recalculate_sides(is_corrupt: bool):
	available_numbers = Global.NUMBERS.duplicate()

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
	return Global.MAX_NUMBER - number
