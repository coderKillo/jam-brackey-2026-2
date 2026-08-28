extends Control

var sub_menu: Control


func _ready():
	%Continue.visible = not GameState.is_new_game()
	%LevelSelect.visible = not GameState.is_new_game()
	%Back.visible = false

	%Continue.pressed.connect(_on_continue_pressed)
	%NewGame.pressed.connect(_on_new_game_pressed)
	%LevelSelect.pressed.connect(_on_level_select_pressed)
	%Options.pressed.connect(_on_option_pressed)
	%Quit.pressed.connect(_on_quit_pressed)
	%Back.pressed.connect(_on_back_pressed)

	%Feedback.pressed.connect(_on_feedback_pressed)

	$ConfimNewGame.confirmed.connect(_on_new_game_confirmed)

	%Version.text = GameState.get_version()

	if OS.has_feature("web"):
		%Quit.hide()


## Handler


func _on_option_pressed():
	_open_sub_menu($Option)


func _on_back_pressed():
	_close_sub_menu()


func _on_continue_pressed():
	SceneManager.load_game_scene()


func _on_new_game_pressed():
	if not GameState.is_new_game():
		$ConfimNewGame.popup_centered()
	else:
		_on_new_game_confirmed()


func _on_new_game_confirmed():
	GameState.reset()
	SceneManager.load_game_scene()


func _on_level_select_pressed():
	_open_sub_menu($LevelSelect)


func _on_quit_pressed():
	get_tree().quit()


func _on_feedback_pressed():
	#TODO: open google docs
	pass


## Helper


func _open_sub_menu(menu: Control) -> void:
	$Menu.hide()
	%Back.show()
	sub_menu = menu
	sub_menu.show()


func _close_sub_menu() -> void:
	sub_menu.hide()
	$Menu.show()
	%Back.hide()
