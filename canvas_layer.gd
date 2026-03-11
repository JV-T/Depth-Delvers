extends CanvasLayer

func transition(scenepath):
	$GPUParticles2D.emitting = true
	$AnimationPlayer.play("fadein")
	await $AnimationPlayer.animation_finished
	$AudioStreamPlayer2.playing = true
	get_tree().change_scene_to_file(scenepath)
	$AnimationPlayer.play_backwards("fadein")
	get_tree().paused = false
	if scenepath == "res://scenes/level.tscn":
		LayerPopup.show_layer(1)


func _on_texture_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Control.visible = !$Control.visible




func _on_button_pressed() -> void:
	get_tree().paused = false
	$Control.visible = false
