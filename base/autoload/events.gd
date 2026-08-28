extends Node

signal level_won

signal level_lose

signal popup_text(text: String, pos: Vector2, color: Color)

signal camera_shake(intensity: float)

signal play_sound(sound: int)

signal people_changed

signal munition_changed

signal building_cleared

signal level_done(corrupt_dices: int)

signal building_selected(id: int)

signal dice_killed(dice: Dice)
