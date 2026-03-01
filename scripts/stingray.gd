extends CharacterBody2D

const SPEED = 110.0
const DAMAGE_PER_SECOND = 8.0
const VERTICAL_AMPLITUDE = 30.0
const VERTICAL_SPEED = 0.7

var _direction: float = 1.0
var _time: float = 0.0
var _player_contact: bool = false
var _player=null
@export var enemyhealth = 100

func _ready() -> void:
	# Randomise start time and direction so each stingray feels independent
	_time = randf() * TAU
	_direction = 1.0 if randf() > 0.5 else -1.0
	$Sprite2D.flip_h = _direction < 0.0
	$HurtArea.body_entered.connect(_on_body_entered)
	$HurtArea.body_exited.connect(_on_body_exited)
func _on_body_entered(body: Node2D) -> void:
	if body.name == "miner":
		_player_contact = true
		_player = body
		
func _physics_process(delta: float) -> void:
	_time += delta
	# Gliding horizontal patrol with gentle sine-wave vertical drift
	var drift = sin(_time * VERTICAL_SPEED) * VERTICAL_AMPLITUDE
	velocity = Vector2(_direction * SPEED, drift)
	move_and_slide()

	# Reverse on wall hit
	if is_on_wall():
		_direction *= -1
		$Sprite2D.flip_h = _direction < 0.0

func _process(delta: float) -> void:
	if _player_contact and !$GPUParticles2D2.emitting:
		$GPUParticles2D2.emitting = true
		UserInterface.shakeamount += 50
		UserInterface.knockback = -10
		UserInterface.oxygen -= DAMAGE_PER_SECOND
		var player_pos=_player.global_position
		
func _on_body_exited(body: Node2D) -> void:
	if body.name == "miner":
		_player_contact = false
