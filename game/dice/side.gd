class_name DiceSide
extends Sprite2D

@export var eyes: Array[Sprite2D] = []

var _lookup = {
	0: [0, 0, 0, 0, 0, 0],
	1: [0, 1, 0, 0, 0, 0],
	2: [1, 0, 0, 0, 0, 1],
	3: [1, 1, 1, 0, 0, 0],
	4: [1, 0, 1, 1, 0, 1],
	5: [1, 1, 1, 1, 0, 1],
	6: [1, 1, 1, 1, 1, 1],
}

var _timer := 0.0


func _ready():
	for eye in $Eyes.get_children():
		eyes.append(eye)
	set_number(randi_range(1, 6))


func _process(delta):
	if _timer > 0.0:
		_timer -= delta
		return

	_timer = 1.0
	for eye in eyes:
		if randf() > 0.90:
			continue
		eye.frame = randi_range(0, 4)


func set_number(number: int):
	if not _lookup.has(number):
		return
	for i in range(eyes.size()):
		if _lookup[number][i] == 1:
			eyes[i].show()
		else:
			eyes[i].hide()


func close():
	for eye in eyes:
		eye.scale.x = 0.0


func open():
	for eye in eyes:
		eye.scale.x = 1.0
