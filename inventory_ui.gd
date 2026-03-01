extends CanvasLayer

const SLOT_SIZE = 80
const MARGIN = 20
const SPACING = 10

var weapon_icon: TextureRect
var powerup_icons: Array = []

func _ready() -> void:
	layer = 10

	var container = HBoxContainer.new()
	container.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	container.position = Vector2(MARGIN, -(MARGIN + SLOT_SIZE + 28))
	container.add_theme_constant_override("separation", SPACING)
	add_child(container)

	var weapon_vbox = _make_slot("WEAPON", Color(0.25, 0.5, 1.0, 1.0))
	container.add_child(weapon_vbox)
	weapon_icon = weapon_vbox.get_meta("icon")

	for i in range(2):
		var pu_vbox = _make_slot("ITEM " + str(i + 1), Color(0.2, 0.85, 0.35, 1.0))
		container.add_child(pu_vbox)
		powerup_icons.append(pu_vbox.get_meta("icon"))


func _make_slot(label_text: String, border_color: Color) -> VBoxContainer:
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)

	var label = Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(label)

	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(SLOT_SIZE, SLOT_SIZE)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.88)
	style.border_color = border_color
	style.set_border_width_all(3)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	panel.add_theme_stylebox_override("panel", style)

	var icon = TextureRect.new()
	icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.offset_left = 8
	icon.offset_top = 8
	icon.offset_right = -8
	icon.offset_bottom = -8
	panel.add_child(icon)

	vbox.add_child(panel)
	vbox.set_meta("icon", icon)
	return vbox


func refresh() -> void:
	if UserInterface.weapon != null:
		weapon_icon.texture = load(UserInterface.weapon.texture_path)
	else:
		weapon_icon.texture = null

	for i in range(2):
		if UserInterface.powerups[i] != null:
			powerup_icons[i].texture = load(UserInterface.powerups[i].texture_path)
		else:
			powerup_icons[i].texture = null
