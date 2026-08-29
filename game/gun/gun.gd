extends Node2D

signal shooting

@export var speed := 5.0
@export var tilt_angle := 45.0

@onready var projectile: ColorRect = $Projectile
@onready var animation: AnimatedSprite2D = $Sprite2D


func _process(delta):
	var mouse_x = get_global_mouse_position().x
	var distance = mouse_x - global_position.x
	var tilt = clamp(distance, -tilt_angle, tilt_angle)
	rotation_degrees = tilt
	global_position.x = lerp(global_position.x, mouse_x, speed * delta)


func _input(event):
	if event is not InputEventMouseButton:
		return
	if not event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		return
	if not event.pressed:
		return

	if GameState.munition > 0:
		GameState.munition -= 1
		shoot()


func shoot():
	var start = global_position
	var end = start + start.direction_to(get_global_mouse_position()) * 1000.0
	var query = PhysicsRayQueryParameters2D.create(start, end)
	query.exclude = [self]
	query.collide_with_areas = true
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result:
		result.collider.kill()

	shooting.emit()
	Events.camera_shake.emit(1.0)
	Events.play_sound.emit(SoundController.SHOOT)
	animation.play("shoot")

	set_process(false)
	await _fire_projectile()
	set_process(true)


func _fire_projectile():
	projectile.scale.x = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(projectile, "scale:x", 0.0, 0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
