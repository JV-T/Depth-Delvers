extends Area2D

var levels = ["res://scenes/level2.tscn", "res://scenes/level3.tscn", "res://scenes/level4.tscn", "res://scenes/level5.tscn"]

func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "miner":
		UserInterface.level += 1
		LayerPopup.show_layer(UserInterface.level + 1)
		transition.transition(levels[randi_range(0,3)])
