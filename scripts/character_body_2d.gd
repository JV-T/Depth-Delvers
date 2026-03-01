extends CharacterBody2D

@export var speed: float = 600.0
@export var rotation_speed: float = 8.0 # Higher = faster rotation
@export var rotation_offset: float = PI / 2 # Adjust based on sprite direction

@onready var anim: AnimatedSprite2D = $playeranimation
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var weapon_sprite: Sprite2D = $WeaponPivot/WeaponSprite
@onready var weapon_anim: AnimationPlayer = $WeaponPivot/WeaponAnimPlayer

var _equipped_weapon_name: String = ""
var _swing_offset: float = 0.0
var _stab_offset: float = 0.0
var _base_weapon_x: float = 0.0
var _is_swinging: bool = false

func _ready() -> void:
	_base_weapon_x = weapon_sprite.position.x

func _physics_process(delta):
	# 1. Get movement input
	if UserInterface.weapon != null and UserInterface.weapon.name == "Trident":
		speed = 1000
	else:
		speed=600
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# 2. Only rotate if there is movement
	if input_vector != Vector2.ZERO:
		# Calculate the target angle (in radians) from input
		var target_angle = input_vector.angle() + rotation_offset
		
		# Smoothly rotate toward target angle
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
		velocity = input_vector.normalized() * speed * (UserInterface.knockback+1)
		UserInterface.knockback *= 0.7
	else:
		velocity = Vector2.ZERO
	if velocity.x > 0:
		$playeranimation.flip_v = false  # facing right
	elif velocity.x < 0:
		$playeranimation.flip_v = true   # facing left
	UserInterface.shakeamount += (abs(velocity.x) + abs(velocity.y))/2000
	# 3. Apply movement with collision
	move_and_slide()

	# Weapon tracks cursor — flip pivot on the left so sword stays upright
	var to_cursor = get_global_mouse_position() - global_position
	if to_cursor.x >= 0.0:
		weapon_pivot.scale.x = 1.0
		weapon_pivot.rotation = to_cursor.angle() + _swing_offset
	else:
		weapon_pivot.scale.x = -1.0
		# Negate offset: scale.x=-1 mirrors the rotation direction, so the swing
		# would go backwards without the negation
		weapon_pivot.rotation = -atan2(to_cursor.y, -to_cursor.x) - _swing_offset

	_update_weapon()

	if Input.is_action_just_pressed("attack"):
		if UserInterface.weapon != null and not _is_swinging:
			UserInterface.shakeamount += 20
			if UserInterface.weapon.attack_type == "stab":
				_do_stab()
			else:
				_do_swing()
			$attackarea.monitorable = true
			$attackarea.monitoring = true
			$Timer.start(0.3 / UserInterface.swing_speed)


func _do_swing() -> void:
	_is_swinging = true
	var spd = UserInterface.swing_speed
	var tween = create_tween()
	# Wind up behind (~70 degrees)
	tween.tween_property(self, "_swing_offset", -1.2, 0.08 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Slash through in a wide arc (~160 degrees total sweep)
	tween.tween_property(self, "_swing_offset", 1.6, 0.12 / spd) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	# Snap back to rest
	tween.tween_property(self, "_swing_offset", 0.0, 0.1 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): _is_swinging = false)


func _do_stab() -> void:
	_is_swinging = true
	var spd = UserInterface.swing_speed
	var tween = create_tween()
	# Pull back slightly
	tween.tween_property(self, "_stab_offset", -10.0, 0.06 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Thrust forward
	tween.tween_property(self, "_stab_offset", 40.0, 0.10 / spd) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	# Return to rest
	tween.tween_property(self, "_stab_offset", 0.0, 0.14 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): _is_swinging = false)


func _update_weapon() -> void:
	var w = UserInterface.weapon
	if w == null:
		weapon_sprite.visible = false
		_equipped_weapon_name = ""
		return

	weapon_sprite.visible = true
	if w.name != _equipped_weapon_name:
		weapon_sprite.texture = load(w.texture_path)
		_equipped_weapon_name = w.name
		weapon_anim.play("weapon/pickup")
	if not weapon_anim.is_playing():
		var s = w.scale
		weapon_sprite.scale = Vector2(s, s)
	weapon_sprite.position.x = _base_weapon_x + _stab_offset


func _on_timer_timeout() -> void:
	$attackarea.monitorable = false
	$attackarea.monitoring = false
