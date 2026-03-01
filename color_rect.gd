extends ColorRect

func _process(delta: float) -> void:
	var alpha_value = abs(UserInterface.downmeters) / 100
	material.set_shader_parameter("alpha", alpha_value)
	print(alpha_value)
