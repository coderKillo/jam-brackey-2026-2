class_name Level
extends Node2D

@export var corruption_chance := 100
@export var corrupted_dices := 3
@export var time_limit := 0.0
@export var has_shadow := false
@export var random_movement := true
@export var corrupt_movement_chance := 1.0
@export var move_intervall_time := 3.0

@onready var dice_group = $DiceGroup
@onready var shadow: Shadow = $Shadow
@onready var timer_bar: ProgressBar = $TimerBar
@onready var overlay_text: RichTextLabel = $OverlayText
@onready var overlay_flash: ColorRect = $FlashOverlay
@onready var theeth_sprite: Node2D = $TeethSprite

var id := 0

var _timer := 0.0
var _level_timer := 0.0


func _ready():
	$Gun.shooting.connect(_on_gun_shooting)
	Events.munition_changed.connect(_on_munition_changed)
	Events.dice_killed.connect(_on_dice_killed)
	set_process(false)
	_setup()
	_show_overlay()


func _show_overlay():
	overlay_text.show()

	await get_tree().create_timer(1.0).timeout

	await TweenAnimation.make_fade_out(overlay_text, 0.5)
	overlay_text.hide()
	set_process(true)


func _setup():
	shadow.visible = has_shadow
	theeth_sprite.hide()

	_level_timer = time_limit
	timer_bar.visible = time_limit > 0.0

	var normal_dices = range(dice_group.get_child_count())
	for i in range(corrupted_dices):
		normal_dices.erase(normal_dices.pick_random())
	for i in range(dice_group.get_child_count()):
		dice_group.get_child(i).corrupt = i in normal_dices
		dice_group.get_child(i).close()


func _process(delta):
	if time_limit > 0.0:
		_level_timer -= delta
		timer_bar.value = _level_timer / time_limit
		if _level_timer <= 0.0:
			end_level()

	_timer -= delta
	if _timer <= 0.0:
		_interval()
		_timer = move_intervall_time


func _interval():
	for dice in dice_group.get_children():
		_process_dice(dice)


func _process_dice(dice: Dice):
	await dice.close()

	if has_shadow and not shadow.has_point(dice.global_position):
		return

	var direction = dice.default_direction
	if random_movement:
		direction = Global.DIRECTIONS.pick_random()
	elif dice.corrupt and (randf() < (corrupt_movement_chance)):
		# Corrupt movement
		if randf() < 0.5:
			direction.x *= -1
		else:
			direction.y *= -1

	Events.play_sound.emit(SoundController.SLIDE)
	await dice.move(direction)

	var is_corrupt = dice.corrupt and (randf() < (corruption_chance / 100.0))
	dice.recalculate_sides(is_corrupt)

	await dice.open()


func end_level():
	set_process(false)
	for dice in dice_group.get_children():
		if not is_instance_valid(dice):
			continue
		if dice.corrupt:
			await _tweeth_animation(dice.global_position)
			GameState.people -= 1
			Events.camera_shake.emit(0.3)
			Events.play_sound.emit(SoundController.DEATH_HUMAN)

	Events.level_done.emit(_corrupted_size())


func _corrupted_size() -> int:
	var size := 0
	for dice in dice_group.get_children():
		if dice.is_queued_for_deletion():
			continue
		if dice.corrupt:
			size += 1
	return size


func _on_gun_shooting():
	TweenAnimation.create_fade_in_out_tween(overlay_flash, 0.1, 0.3)


func _on_munition_changed():
	if GameState.munition <= 0:
		end_level()


func _on_dice_killed(_dice: Dice):
	if _corrupted_size() <= 0:
		end_level()


func _tweeth_animation(start_position: Vector2):
	theeth_sprite.show()
	theeth_sprite.global_position = start_position
	theeth_sprite.scale = Vector2.ONE
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(theeth_sprite, "scale", Vector2(20.0, 20.0), 0.5)
	tween.tween_property(theeth_sprite, "global_position", Vector2(320.0, 180.0), 0.5)
	await tween.finished
	tween = TweenAnimation.create_fade_in_out_tween(overlay_flash, 0.4, 0.1)
	await tween.finished
	theeth_sprite.hide()
