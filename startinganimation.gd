extends CanvasLayer

var button_theme: Theme
var settings_menu: Control
var world_environment_checkbox: CheckButton

func _ready() -> void:
	Parallax2d.visible = false
	_setup_button_theme()
	_add_title()
	_style_buttons()
	_create_settings_menu()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0

func _setup_button_theme() -> void:
	button_theme = Theme.new()
	
	# Normal state
	var normal_stylebox = StyleBoxFlat.new()
	normal_stylebox.bg_color = Color(0.2, 0.5, 0.8, 0.8)
	normal_stylebox.border_color = Color(0.96, 0.90, 0.68, 1.0)
	normal_stylebox.border_width_left = 2
	normal_stylebox.border_width_right = 2
	normal_stylebox.border_width_top = 2
	normal_stylebox.border_width_bottom = 2
	normal_stylebox.corner_radius_top_left = 8
	normal_stylebox.corner_radius_top_right = 8
	normal_stylebox.corner_radius_bottom_left = 8
	normal_stylebox.corner_radius_bottom_right = 8
	normal_stylebox.content_margin_left = 12
	normal_stylebox.content_margin_right = 12
	normal_stylebox.content_margin_top = 12
	normal_stylebox.content_margin_bottom = 12
	button_theme.set_stylebox("normal", "Button", normal_stylebox)
	
	# Hover state
	var hover_stylebox = StyleBoxFlat.new()
	hover_stylebox.bg_color = Color(0.3, 0.6, 0.95, 0.9)
	hover_stylebox.border_color = Color(1.0, 0.95, 0.7, 1.0)
	hover_stylebox.border_width_left = 3
	hover_stylebox.border_width_right = 3
	hover_stylebox.border_width_top = 3
	hover_stylebox.border_width_bottom = 3
	hover_stylebox.corner_radius_top_left = 8
	hover_stylebox.corner_radius_top_right = 8
	hover_stylebox.corner_radius_bottom_left = 8
	hover_stylebox.corner_radius_bottom_right = 8
	hover_stylebox.content_margin_left = 12
	hover_stylebox.content_margin_right = 12
	hover_stylebox.content_margin_top = 12
	hover_stylebox.content_margin_bottom = 12
	button_theme.set_stylebox("hover", "Button", hover_stylebox)
	
	# Pressed state
	var pressed_stylebox = StyleBoxFlat.new()
	pressed_stylebox.bg_color = Color(0.15, 0.4, 0.7, 0.85)
	pressed_stylebox.border_color = Color(0.85, 0.80, 0.60, 1.0)
	pressed_stylebox.border_width_left = 3
	pressed_stylebox.border_width_right = 3
	pressed_stylebox.border_width_top = 3
	pressed_stylebox.border_width_bottom = 3
	pressed_stylebox.corner_radius_top_left = 8
	pressed_stylebox.corner_radius_top_right = 8
	pressed_stylebox.corner_radius_bottom_left = 8
	pressed_stylebox.corner_radius_bottom_right = 8
	pressed_stylebox.content_margin_left = 12
	pressed_stylebox.content_margin_right = 12
	pressed_stylebox.content_margin_top = 12
	pressed_stylebox.content_margin_bottom = 12
	button_theme.set_stylebox("pressed", "Button", pressed_stylebox)
	
	# Text colors
	button_theme.set_color("font_color", "Button", Color(0.96, 0.90, 0.68, 1.0))
	button_theme.set_color("font_hover_color", "Button", Color(1.0, 0.95, 0.7, 1.0))
	button_theme.set_color("font_pressed_color", "Button", Color(0.85, 0.80, 0.60, 1.0))
	button_theme.set_color("font_focus_color", "Button", Color(1.0, 0.95, 0.7, 1.0))


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


func _style_buttons() -> void:
	# Add a semi-transparent background panel behind the menu
	var menu_bg = ColorRect.new()
	menu_bg.anchors_preset = 8
	menu_bg.anchor_left = 0.5
	menu_bg.anchor_top = 0.5
	menu_bg.anchor_right = 0.5
	menu_bg.anchor_bottom = 0.5
	menu_bg.offset_left = -150
	menu_bg.offset_top = -130
	menu_bg.offset_right = 150
	menu_bg.offset_bottom = 190
	menu_bg.color = Color(0.0, 0.3, 0.5, 0.3)
	add_child(menu_bg)
	move_child(menu_bg, 0)
	
	# Apply theme to all buttons
	for button in [$Button, $Button2, $Button3,$Button4]:
		button.theme = button_theme
		button.add_theme_font_size_override("font_size", 36)
		button.custom_minimum_size = Vector2(220, 50)
		button.pivot_offset = Vector2(110, 25)
		button.mouse_entered.connect(func(): _on_button_hover(button, true))
		button.mouse_exited.connect(func(): _on_button_hover(button, false))
	
	# Initialize diver color to white
	$AnimatedSprite2D.modulate = Color.WHITE
	
	# Connect Settings button to show settings menu
	$Button3.pressed.connect(Callable(self, "_on_settings_pressed"))


func _on_button_hover(button: Button, is_hovering: bool) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	if is_hovering:
		tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.2)
	else:
		tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)


func _create_settings_menu() -> void:
	settings_menu = Control.new()
	settings_menu.anchors_preset = 15
	settings_menu.visible = false
	add_child(settings_menu)
	
	# Background overlay
	var overlay = ColorRect.new()
	overlay.anchors_preset = 15
	overlay.color = Color(0.0, 0.0, 0.0, 0.5)
	settings_menu.add_child(overlay)
	
	# Settings panel
	var panel_bg = ColorRect.new()
	panel_bg.set_anchors_preset(Control.PRESET_CENTER)
	# Use a centered panel sized for typical 1920x1080 fullscreen
	# Content area is 600x360 which looks good on 1080p while leaving margins
	panel_bg.custom_minimum_size = Vector2(1920, 1080)
	panel_bg.color = Color(0.0, 0.3, 0.5, 0.8)
	settings_menu.add_child(panel_bg)
	
	# Settings container - fill the panel
	var vbox = VBoxContainer.new()
	vbox.anchors_preset = 15
	vbox.offset_left = 20
	vbox.offset_top = 20
	vbox.offset_right = -20
	vbox.offset_bottom = -20
	vbox.add_theme_constant_override("separation", 20)
	panel_bg.add_child(vbox)
	
	# Settings title
	var title = Label.new()
	title.text = "Settings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.96, 0.90, 0.68))
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color(0.55, 0.35, 0.05, 1.0))
	vbox.add_child(title)
	
	# World Environment setting
	var env_container = HBoxContainer.new()
	env_container.add_theme_constant_override("separation", 15)
	env_container.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(env_container)
	
	var env_label = Label.new()
	env_label.text = "World Environment:"
	env_label.add_theme_font_size_override("font_size", 24)
	env_label.add_theme_color_override("font_color", Color(0.96, 0.90, 0.68))
	env_container.add_child(env_label)
	
	world_environment_checkbox = CheckButton.new()
	world_environment_checkbox.button_pressed = true
	world_environment_checkbox.add_theme_font_size_override("font_size", 20)
	world_environment_checkbox.add_theme_color_override("font_color", Color(0.96, 0.90, 0.68))
	world_environment_checkbox.toggled.connect(Callable(self, "_on_world_env_toggled"))
	env_container.add_child(world_environment_checkbox)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)
	
	# Back button
	var back_button = Button.new()
	back_button.text = "Back"
	back_button.theme = button_theme
	back_button.add_theme_font_size_override("font_size", 32)
	back_button.custom_minimum_size = Vector2(200, 50)
	back_button.pivot_offset = Vector2(100, 25)
	back_button.pressed.connect(Callable(self, "_on_settings_back"))
	vbox.add_child(back_button)
	back_button.mouse_entered.connect(func(): _on_button_hover(back_button, true))
	back_button.mouse_exited.connect(func(): _on_button_hover(back_button, false))


func _on_settings_pressed() -> void:
	settings_menu.visible = true
	$Button.hide()
	$Button2.hide()
	$Button3.hide()
	$Button4.hide()
	$ColorPicker.hide()


func _on_settings_back() -> void:
	settings_menu.visible = false
	$Button.show()
	$Button2.show()
	$Button3.show()
	$Button4.show()


func _on_world_env_toggled(toggled_on: bool) -> void:
	# Store the setting globally so it persists in-game
	if UserInterface:
		UserInterface.world_environment_enabled = toggled_on
	else:
		push_error("UserInterface autoload not found")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Parallax2d.visible = true
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	LayerPopup.show_layer(1)


func _on_button_pressed() -> void:
	$Button.hide()
	$Button2.hide()
	$Button3.hide()
	$Button4.hide()
	$ColorPicker.hide()
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D/AnimationPlayer.play("startinganimation")


func _on_button_2_pressed() -> void:
	$ColorPicker.visible = !$ColorPicker.visible
	
#func _on_button_4_pressed()->void:
	

func _on_color_picker_color_changed(color: Color) -> void:
	# Ensure the color is never completely black by boosting the minimum brightness
	var adjusted_color = color
	var brightness = (color.r + color.g + color.b) / 3.0
	if brightness < 0.1:
		adjusted_color = Color(0.15, 0.15, 0.15, color.a)
	
	UserInterface.colorpicked = adjusted_color
	$AnimatedSprite2D.modulate = adjusted_color
