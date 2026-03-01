extends CanvasLayer


func _ready() -> void:
	Parallax2d.visible = false
	_add_title()


func _add_title() -> void:
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 14)
	vbox.anchor_left = 1.0
	vbox.anchor_right = 1.0
	vbox.anchor_top = 0.0
	vbox.anchor_bottom = 0.0
	vbox.offset_left = -500
	vbox.offset_right = -30
	vbox.offset_top = 20
	vbox.offset_bottom = 160
	add_child(vbox)

	# Top decoration
	vbox.add_child(_make_decoration())

	# Title with glow shadow (stacked labels)
	var title_stack = Control.new()
	title_stack.custom_minimum_size = Vector2(460, 70)

	var shadow = Label.new()
	shadow.set_anchors_preset(Control.PRESET_FULL_RECT)
	shadow.text = "Depth Delvers"
	shadow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shadow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	shadow.add_theme_font_size_override("font_size", 52)
	shadow.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 0.0))
	shadow.add_theme_constant_override("outline_size", 24)
	shadow.add_theme_color_override("font_outline_color", Color(1.0, 0.7, 0.1, 0.18))
	title_stack.add_child(shadow)

	var title = Label.new()
	title.set_anchors_preset(Control.PRESET_FULL_RECT)
	title.text = "Depth Delvers"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color(0.96, 0.90, 0.68))
	title.add_theme_constant_override("outline_size", 5)
	title.add_theme_color_override("font_outline_color", Color(0.55, 0.35, 0.05, 1.0))
	title.add_theme_color_override("font_shadow_color", Color(1.0, 0.75, 0.2, 0.45))
	title.add_theme_constant_override("shadow_offset_x", 0)
	title.add_theme_constant_override("shadow_offset_y", 0)
	title_stack.add_child(title)

	vbox.add_child(title_stack)

	# Bottom decoration
	vbox.add_child(_make_decoration())


func _make_decoration() -> HBoxContainer:
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 10)

	var line_l = ColorRect.new()
	line_l.custom_minimum_size = Vector2(160, 1)
	line_l.color = Color(0.85, 0.68, 0.28, 0.85)

	var diamond = Label.new()
	diamond.text = "◆"
	diamond.add_theme_font_size_override("font_size", 13)
	diamond.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35, 1.0))
	diamond.add_theme_constant_override("outline_size", 3)
	diamond.add_theme_color_override("font_outline_color", Color(0.6, 0.35, 0.05, 0.8))

	var line_r = ColorRect.new()
	line_r.custom_minimum_size = Vector2(160, 1)
	line_r.color = Color(0.85, 0.68, 0.28, 0.85)

	hbox.add_child(line_l)
	hbox.add_child(diamond)
	hbox.add_child(line_r)
	return hbox

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Parallax2d.visible = true
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	LayerPopup.show_layer(1)
