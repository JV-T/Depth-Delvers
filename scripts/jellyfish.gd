extends Area2D

const DAMAGE_PER_SECOND = 12.0
const BOB_SPEED = 1.8
const BOB_AMPLITUDE = 60.0
const DRIFT_SPEED = 0.35
const DRIFT_RANGE = 90.0

var _player_contact: bool = false
@export var enemyhealth = 100

var _origin: Vector2
var _time: float = 0.0  # added this
var _phase: float = 0.0
var _initialized: bool = false


func _ready() -> void:
	_phase = randf() * TAU
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	# Lazily capture origin — spawner sets global_position AFTER _ready fires
	if not _initialized:
		_origin = global_position
		_initialized = true

	_time += delta  # increment time each frame

	global_position.y = _origin.y + sin(_time * BOB_SPEED + _phase) * BOB_AMPLITUDE
	global_position.x = _origin.x + sin(_time * DRIFT_SPEED + _phase * 0.7) * DRIFT_RANGE
	$ProgressBar.value = enemyhealth
	if _player_contact and !$GPUParticles2D2.emitting and $Timer.is_stopped():
		UserInterface.knockback = -10
		UserInterface.oxygen -= DAMAGE_PER_SECOND
		$Timer.start()
		$GPUParticles2D2.emitting = true


func _on_body_entered(body: Node2D) -> void:
	if body.name == "miner":
		_player_contact = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "miner":
		_player_contact = false


func _on_area_entered(area: Area2D) -> void:
	if area.name == "attackarea":
		enemyhealth -= UserInterface.damage
		UserInterface.shakeamount += 40
		$bloodeffect.emitting = true
		if enemyhealth < 0:
			queue_free()
			UserInterface.shakeamount += 80
			UserInterface.oxygen += 20
			if UserInterface.oxygen > 100:
				UserInterface.oxygen = 100
