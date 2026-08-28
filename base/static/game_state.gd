class_name GameState
extends Node

const SAVE_STATE_PATH = "user://global_state.tres"
const NO_VERSION_NAME = "0.0.0"

static var current: GameData

static var people: int:
	set = set_people,
	get = get_people

static var munition: int:
	set = set_munition,
	get = get_munition


static func _log_version() -> void:
	var current_version = ProjectSettings.get_setting("application/config/version", NO_VERSION_NAME)
	if current_version.is_empty():
		current_version = NO_VERSION_NAME
	current.version_opened = current_version


static func _load_current_state() -> void:
	if FileAccess.file_exists(SAVE_STATE_PATH):
		current = ResourceLoader.load(SAVE_STATE_PATH)
	if not current:
		current = GameData.new()


static func open() -> void:
	_load_current_state()
	_log_version()
	save()


static func save() -> void:
	if current is GameData:
		ResourceSaver.save(current, SAVE_STATE_PATH)
		current.changed.emit()


static func reset() -> void:
	if current is not GameData:
		return
	current = GameData.new()
	save()


static func get_version() -> String:
	return current.version_opened


static func is_new_game() -> bool:
	return current.people == Global.START_POPULATION and current.munition <= 0


static func set_munition(value: int):
	current.munition = value
	save()
	Events.munition_changed.emit()


static func get_munition() -> int:
	return current.munition


static func set_people(value: int):
	current.people = value
	save()
	Events.people_changed.emit()


static func get_people() -> int:
	return current.people


static func set_building_cleared(index: int):
	current.buildings_cleared.append(index)
	save()
	Events.building_cleared.emit()


static func is_building_cleared(index: int) -> bool:
	return index in current.buildings_cleared


static func start_game() -> void:
	save()
