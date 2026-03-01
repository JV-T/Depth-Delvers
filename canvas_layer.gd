extends CanvasLayer

func transition(scenepath):
	$AnimationPlayer.play("fadein")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scenepath)
	$AnimationPlayer.play_backwards("fadein")
	get_tree().paused = false
	if scenepath == "res://scenes/level.tscn":
		LayerPopup.show_layer(1)
