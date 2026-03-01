extends CanvasLayer


func _process(delta: float) -> void:
	if UserInterface.oxygen <= 0:
		visible = true
		get_tree().paused = true
		$highscore.text = "Score: " + str(UserInterface.downmeters) + "m"


func _on_button_pressed() -> void:
	UserInterface.oxygen = 100
	UserInterface.level = 0
	UserInterface.weapon = null
	UserInterface.powerups = [null, null]
	UserInterface.damage = 30
	UserInterface.base_damage = 30
	UserInterface.swing_speed = 1.0
	UserInterface.speed_multiplier = 1.0
	UserInterface.damage_multiplier = 1.0
	# Remove any active powerup timers
	for child in UserInterface.get_children():
		if child is Timer:
			child.queue_free()
	UserInterface.active_timers.clear()
	InventoryUI.restart()
	transition.transition("res://scenes/level.tscn")
	visible = false
