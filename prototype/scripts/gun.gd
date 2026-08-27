extends Node2D

@export var speed := 10.0
@export var tilt_angle := 10.0


func _process(delta):
	var mouse_x = get_global_mouse_position().x
	var distance = mouse_x - global_position.x
	var tilt = clamp(distance, -tilt_angle, tilt_angle)
	rotation_degrees = tilt
	global_position.x = lerp(global_position.x, mouse_x, speed * delta)


func shoot():
	var start = global_position
	var end = start + start.direction_to(get_global_mouse_position()) * 1000.0
	var query = PhysicsRayQueryParameters2D.create(start, end)
	query.exclude = [self]
	query.collide_with_areas = true
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result:
		result.collider.get_parent().clicked.emit()

	var projectile = $Projectile
	projectile.scale.x = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(projectile, "scale:x", 0.0, 0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
