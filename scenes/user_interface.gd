extends Node

var oxygen = 100
var level = 0
var downmeters = 0
var knockback = 0
var shakeamount = 0
# Inventory: 1 weapon slot, 2 powerup slots
# Each item is a Dictionary: { name, type, texture_path }
var weapon = null
var powerups = [null, null]


# Always places the item into its slot. Returns the displaced item (or {} if slot was empty).
func swap_item(item_data: Dictionary) -> Dictionary:
	if item_data.type == "weapon":
		var old = weapon if weapon != null else {}
		weapon = item_data
		return old

	elif item_data.type == "powerup":
		# Fill an empty slot first
		for i in range(powerups.size()):
			if powerups[i] == null:
				powerups[i] = item_data
				return {}
		# Both slots full — swap slot 0
		var old = powerups[0]
		powerups[0] = item_data
		return old

	return {}
