extends ColorRect

func _process(delta: float) -> void:
	var vhseffect = UserInterface.level
	if vhseffect > 3:
		vhseffect = 3
	material.set_shader_parameter("vhs_intensity", vhseffect)
