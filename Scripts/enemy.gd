extends CharacterBody2D

signal died
signal tomou_dano

var fugir := false
var fugindo := false

var speed: float = 80.0
var max_health: int = 100
var projectile_scene: PackedScene = preload("res://Scenes/enemyProjectile.tscn")
var shoot_cooldown: float = 2.0
var number_of_cannons: int = 1
var follow_distance: float = 300.0

@export var player: Node2D
@export var pode_atacar := false

var current_health: int = max_health
var time_since_last_shot: float = 0.0

@onready var animated_sprite = $Sail
@onready var animated_leftTrail = $waterLeftAnim
@onready var animated_rightTrail = $waterRightAnim
@onready var animated_upTrail = $waterUpAnim
@onready var animated_downTrail = $waterDownAnim
@onready var animated_upRightTrail = $waterUpRightAnim
@onready var animated_upLeftTrail = $waterUpLeftAnim
@onready var animated_downRightTrail = $waterDownRightAnim
@onready var animated_downLeftTrail = $waterDownLeftAnim
@onready var health_bar = $HealthBar
@onready var cooldown_ui = $CooldownIndicator

var last_direction: Vector2 = Vector2.DOWN
var last_trail: Node = null

func _ready():
	add_to_group("inimigos")
	last_trail = animated_rightTrail
	animated_sprite.play("sailRight")
	continue_trail_idle()
	health_bar.max_health = max_health
	health_bar.set_health(current_health)
	
	call_deferred("_conectar_com_inimigos")

func _process(delta):
	if not fugir:
		time_since_last_shot += delta
		var direction = Vector2.ZERO
		
		if player:
			var to_player = player.global_position - global_position
			var distance = to_player.length()
			var to_player_normalized = to_player.normalized()
			update_animation(to_player_normalized)

			if pode_atacar:
				if time_since_last_shot >= shoot_cooldown:
					await shoot(to_player_normalized)
					time_since_last_shot = 0.0

				if distance > follow_distance:
					direction = to_player_normalized

				for other in get_tree().get_nodes_in_group("inimigos"):
					if other != self and other is CharacterBody2D:
						var dist = global_position.distance_to(other.global_position)
						var min_dist = 400.0
						if dist < min_dist and dist > 0:
							var repulsion = (global_position - other.global_position).normalized()
							direction += repulsion * ((min_dist - dist) / min_dist)

		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			continue_trail_idle()

		move_and_slide()
	elif fugir:
		if not fugindo:
			live()
			fugindo = true

func update_animation(direction: Vector2):
	hide_all_trails()
	animated_sprite.speed_scale = 1.0
	last_direction = direction

	if direction.y > 0:
		if direction.x > 0:
			animated_sprite.play("sailDownRight")
			last_trail = animated_downRightTrail
		elif direction.x < 0:
			animated_sprite.play("sailDownLeft")
			last_trail = animated_downLeftTrail
		else:
			animated_sprite.play("sailDown")
			last_trail = animated_downTrail
	elif direction.y < 0:
		if direction.x > 0:
			animated_sprite.play("sailUpRight")
			last_trail = animated_upRightTrail
		elif direction.x < 0:
			animated_sprite.play("sailUpLeft")
			last_trail = animated_upLeftTrail
		else:
			animated_sprite.play("sailUp")
			last_trail = animated_upTrail
	else:
		if direction.x > 0:
			animated_sprite.play("sailRight")
			last_trail = animated_rightTrail
		elif direction.x < 0:
			animated_sprite.play("sailLeft")
			last_trail = animated_leftTrail

	if last_trail:
		last_trail.visible = true
		last_trail.speed_scale = 1.0
		last_trail.scale.x = 2.353
		last_trail.play()

func continue_trail_idle():
	hide_all_trails()
	animated_sprite.speed_scale = 0.3
	animated_sprite.play()
	if last_trail:
		last_trail.visible = true
		last_trail.speed_scale = 0.3
		last_trail.scale.x = 2
		last_trail.play()

func hide_all_trails():
	animated_leftTrail.visible = false
	animated_rightTrail.visible = false
	animated_upTrail.visible = false
	animated_downTrail.visible = false
	animated_upRightTrail.visible = false
	animated_upLeftTrail.visible = false
	animated_downRightTrail.visible = false
	animated_downLeftTrail.visible = false

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_bar.set_health(current_health)
	pode_atacar = true
	emit_signal("tomou_dano")

	if current_health <= 0:
		die()

func die():
	emit_signal("died")
	queue_free()

func shoot(base_direction: Vector2) -> void:
	if not projectile_scene:
		return

	for i in range(number_of_cannons):
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.direction = base_direction
		get_tree().current_scene.add_child(projectile)

		if i < number_of_cannons - 1:
			await get_tree().create_timer(0.1).timeout

	if cooldown_ui:
		cooldown_ui.start(shoot_cooldown)
		
func live():
	pode_atacar = false
	animated_sprite.play("sailDownLeft")
	last_trail = animated_downLeftTrail
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
	
	var direcao_saida := Vector2(-1, 1).normalized()
	var velocidade_saida := 80.0

	set_process(true)

	var tempo := 0.0
	while tempo < 10.0:
		position += direcao_saida * velocidade_saida * get_process_delta_time()
		await get_tree().process_frame
		tempo += get_process_delta_time()
	queue_free()
	
func _conectar_com_inimigos():
	for other in get_tree().get_nodes_in_group("inimigos"):
		if other != self and other.has_signal("tomou_dano"):
			other.tomou_dano.connect(_on_aliado_tomou_dano, CONNECT_DEFERRED)
	
func _on_aliado_tomou_dano():
	if not pode_atacar and not fugir:
		pode_atacar = true
