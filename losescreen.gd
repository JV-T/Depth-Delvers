extends CanvasLayer


func _process(delta: float) -> void:
	if UserInterface.oxygen <= 0:
		visible = true
		get_tree().paused = true
		$highscore.text = "Highscore: " + str(((UserInterface.downmeters + 1990) * -0.01) + -44 * UserInterface.level) + "m"


func _on_button_pressed() -> void:
	UserInterface.oxygen = 100
	UserInterface.level = 0
	UserInterface.weapon = null
	UserInterface.powerups = [null, null]
	InventoryUI.refresh()
	transition.transition("res://scenes/level.tscn")
	visible = false
