extends Control

@export var eyes: Array[Control] = []

var _lookup = {
	0: [0, 0, 0, 0, 0, 0, 0, 0, 0],
	1: [0, 0, 0, 0, 1, 0, 0, 0, 0],
	2: [0, 0, 1, 0, 0, 0, 1, 0, 0],
	3: [0, 0, 1, 0, 1, 0, 1, 0, 0],
	4: [1, 0, 1, 0, 0, 0, 1, 0, 1],
	5: [1, 0, 1, 0, 1, 0, 1, 0, 1],
	6: [1, 0, 1, 1, 0, 1, 1, 0, 1],
}


func _ready():
	set_number(randi_range(1, 6))


func set_number(number: int):
	if not _lookup.has(number):
		return
	for i in range(eyes.size()):
		if _lookup[number][i] == 1:
			eyes[i].show()
		else:
			eyes[i].hide()


func close():
	var tween = self.create_tween()
	tween.set_parallel(true)
	for eye in eyes:
		(
			tween
			. tween_property(eye, "scale:y", 0.0, randf_range(0.1, 0.3))
			. set_ease(Tween.EASE_OUT)
			. set_trans(Tween.TRANS_EXPO)
		)
	await tween.finished


func open():
	var tween = self.create_tween()
	tween.set_parallel(true)
	for eye in eyes:
		(
			tween
			. tween_property(eye, "scale:y", 0.2, randf_range(0.1, 0.3))
			. set_ease(Tween.EASE_IN)
			. from(0.0)
			. set_trans(Tween.TRANS_EXPO)
		)
	await tween.finished
