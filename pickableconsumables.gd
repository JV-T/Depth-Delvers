extends Node2D

const SPRITESHEET = preload("res://Power Ups/platformer items - free assets/static_items.png")

const CONSUMABLES = [
	{"name": "Oxygen Tank", "type": "powerup", "frame": 0, "region": Rect2(64, 0, 32, 32)},
	{"name": "Speed Potion", "type": "powerup", "frame": 1, "region": Rect2(0, 64, 32, 32)},
	{"name": "Damage Potion", "type": "powerup", "frame": 2, "region": Rect2(32, 64, 32, 32)}
]

var item_data: Dictionary = {}
var player_in_range: bool = false


func _make_texture(region: Rect2) -> AtlasTexture:
	var tex = AtlasTexture.new()
	tex.atlas = SPRITESHEET
	tex.region = region
	return tex


func _ready() -> void:
	item_data = CONSUMABLES[randi_range(0, CONSUMABLES.size() - 1)].duplicate()
	item_data["texture"] = _make_texture(item_data.region)
	$"item sprite".texture = item_data.texture
	$"item sprite".scale = Vector2(0.5, 0.5)
	$"item sprite/AnimationPlayer".play("open")

	var area = Area2D.new()
	area.name = "PickupArea"
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 40.0
	shape.shape = circle
	area.add_child(shape)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	add_child(area)


func _prompt_text() -> String:
	var already_have = (UserInterface.powerups[0] != null and UserInterface.powerups[0].name == item_data.name) \
		or (UserInterface.powerups[1] != null and UserInterface.powerups[1].name == item_data.name)
	var slot_full = UserInterface.powerups[0] != null and UserInterface.powerups[1] != null

	if already_have:
		return item_data.name + "  [Already have this]"
	elif slot_full:
		return item_data.name + "  —  Swap"
	else:
		return item_data.name + "  —  Pick Up"


func _already_have() -> bool:
	return (UserInterface.powerups[0] != null and UserInterface.powerups[0].name == item_data.name) \
		or (UserInterface.powerups[1] != null and UserInterface.powerups[1].name == item_data.name)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "miner":
		player_in_range = true
		PromptUI.show_prompt(_prompt_text())


func _on_body_exited(body: Node2D) -> void:
	if body.name == "miner":
		player_in_range = false
		PromptUI.hide_prompt()


func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		if _already_have():
			return
		var old_item = UserInterface.swap_item(item_data)
		InventoryUI.refresh()

		if old_item.is_empty():
			PromptUI.show_prompt("Press 1/2 to select slot, F to consume", false)
			$"item sprite".visible = false
			player_in_range = false
			queue_free()
		else:
			item_data = old_item
			$"item sprite".texture = item_data.texture
			PromptUI.show_prompt(_prompt_text())
