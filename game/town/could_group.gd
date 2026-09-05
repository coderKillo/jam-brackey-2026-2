extends Node2D

@export var fade_time := 3.0

@onready var cloud1: Node2D = $Clouds1
@onready var cloud2: Node2D = $Clouds2
@onready var cloud3: Node2D = $Clouds3


func _ready():
	Events.building_cleared.connect(_on_building_cleared)
	_on_building_cleared()


func _on_building_cleared():
	if GameState.is_building_cleared(1) and cloud1.visible:
		await _fade_cloud(cloud1)
		await _fade_cloud(cloud2)

	if range(2, 6).all(func(n): GameState.is_building_cleared(n)) and cloud3.visible:
		await _fade_cloud(cloud3)


func _fade_cloud(cloud: Node2D):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(cloud, "position:x", cloud.position.x + 200, fade_time)
	tween.tween_property(cloud, "modulate:a", 0.0, fade_time)
	tween.set_parallel(false)
	tween.tween_callback(cloud.hide)
	await tween.finished
