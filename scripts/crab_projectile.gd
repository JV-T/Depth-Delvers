extends Area2D

@export var damage: float = 15.0
@export var speed: float = 900
@export var max_distance: float = 1200

var _distance_traveled: float = 0.0
var _pierce_count: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	var step = speed * delta
	position += transform.x * step
	_distance_traveled += step
	if _distance_traveled >= max_distance:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("walls") or body is TileMap:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HurtArea" or area.name == "hurtarea" or area.name == "hurt_area":
		queue_free()
