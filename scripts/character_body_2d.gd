extends CharacterBody2D
@export var speed: float = 600.0
@export var rotation_speed: float = 8.0
@export var rotation_offset: float = PI / 2
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
	$playeranimation.modulate = UserInterface.colorpicked
	weapon_pivot.position = Vector2.ZERO
	_base_weapon_x = weapon_sprite.position.x
func _physics_process(delta):
	if UserInterface.weapon != null and UserInterface.weapon.name == "Trident":
		speed = 800 * UserInterface.speed_multiplier
	else:
		speed = 600 * UserInterface.speed_multiplier
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input_vector != Vector2.ZERO:
		var target_angle = input_vector.angle() + rotation_offset
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		velocity = input_vector.normalized() * speed * (UserInterface.knockback+1)
		UserInterface.knockback *= 0.7
	else:
		velocity = Vector2.ZERO
	if velocity.x > 0:
		$playeranimation.flip_h = false
	elif velocity.x < 0:
		$playeranimation.flip_h = true
	var approxspeed = (abs(velocity.x) + abs(velocity.y))/2000
	UserInterface.shakeamount += approxspeed
	scale = Vector2(1.176 - approxspeed / 5, 1.207 - approxspeed / 5)
	move_and_slide()
	weapon_pivot.position = Vector2.ZERO
	weapon_pivot.rotation = (rotation - rotation_offset) + _swing_offset
	_update_weapon()
	if Input.is_action_pressed("attack"):
		if UserInterface.weapon != null and not _is_swinging:
			UserInterface.shakeamount += 20
			$AudioStreamPlayer.play()
			if UserInterface.weapon.attack_type == "stab":
				_do_stab()
			else:
				_do_swing()
			$attackarea.monitorable = true
			$attackarea.monitoring = true
			$Timer.start(3.0 / UserInterface.swing_speed)
func _do_swing() -> void:
	_is_swinging = true
	var spd = UserInterface.swing_speed
	var tween = create_tween()
	tween.tween_property(self, "_swing_offset", -1.2, 0.08 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "_swing_offset", 1.6, 0.12 / spd) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "_swing_offset", 0.0, 0.1 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): _is_swinging = false)
func _do_stab() -> void:
	_is_swinging = true
	var spd = UserInterface.swing_speed
	var tween = create_tween()
	tween.tween_property(self, "_stab_offset", -10.0, 0.06 / spd) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "_stab_offset", 40.0, 0.10 / spd) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
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
