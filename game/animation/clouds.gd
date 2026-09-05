extends CanvasGroup

@export var distance := 0.0
@export var amplitude := 1.0
@export var time := 1.0


func _ready():
	_setup()


func _setup():
	for child in get_children():
		var rng_time = time * randf_range(1.0, 3.0)
		var rng_sign = -1 if randf() > 0.5 else 1

		var x_tween := child.create_tween()
		x_tween.set_ease(Tween.EASE_IN_OUT)
		x_tween.set_trans(Tween.TRANS_QUAD)
		(
			x_tween
			. tween_property(
				child, "position:x", child.position.x + rng_sign * distance, rng_time / 2.0
			)
			. from(child.position.x)
		)
		x_tween.tween_property(child, "position:x", child.position.x, rng_time / 2.0).from(
			child.position.x + rng_sign * distance
		)
		x_tween.set_loops()
		var y_tween := child.create_tween()
		y_tween.set_ease(Tween.EASE_IN_OUT)
		y_tween.set_trans(Tween.TRANS_QUAD)
		(
			y_tween
			. tween_property(child, "position:y", child.position.y + amplitude, rng_time / 4.0)
			. from(child.position.y)
		)
		y_tween.tween_property(child, "position:y", child.position.y, rng_time / 4.0).from(
			child.position.y + amplitude
		)
		y_tween.set_loops()
