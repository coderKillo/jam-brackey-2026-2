extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]

signal level_end(corupted: int)

@export var move_intervall_time := 3.0

var ammo := 0

var _timer := 0.0


func _ready():
	_timer = move_intervall_time
	var entities := get_tree().get_nodes_in_group("entity")
	entities.pick_random().corrupt = true
	entities.pick_random().corrupt = true
	entities.pick_random().corrupt = true
	for entity in entities:
		entity.clicked.connect(_on_entity_clicked.bind(entity))


func _process(delta):
	_timer -= delta
	if _timer <= 0.0:
		_interval()
		_timer = move_intervall_time


func _interval():
	for entity in get_tree().get_nodes_in_group("entity"):
		entity.move(DIRECTIONS.pick_random())


func _on_entity_clicked(entity):
	entity.queue_free()


func shoot():
	ammo -= 1
	await $Gun.shoot()

	if _corrupted_size() <= 0 or ammo <= 0:
		end_level()


func end_level():
	level_end.emit(_corrupted_size())


func _corrupted_size() -> int:
	var size := 0
	for entity in get_tree().get_nodes_in_group("entity"):
		if entity.corrupt:
			size += 1
	return size
