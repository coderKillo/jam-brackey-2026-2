extends OverlaidMenu


func _ready():
	%MainMenu.pressed.connect(_on_main_menu_pressed)
	%Restart.pressed.connect(_on_restart_pressed)
	%Continue.pressed.connect(_on_continue_pressed)
	%SubTitle.text = "%s People survived" % GameState.people

	%Continue.visible = false


func _on_main_menu_pressed():
	SceneManager.load_main_menu()
	close()


func _on_restart_pressed():
	SceneManager.reload_level()
	close()


func _on_continue_pressed():
	SceneManager.advance_level()
	close()
