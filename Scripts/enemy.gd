extends CharacterBody2D

signal died

var speed: float = 80.0
var max_health: int = 100
var projectile_scene: PackedScene = preload("res://Scenes/enemyProjectile.tscn")
var shoot_cooldown: float = 1.0
var number_of_cannons: int = 1
var follow_distance: float = 300.0

@onready var player: Node2D = get_node_or_null("/root/Main/Player")

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

var pode_atacar := false
var formacao_index := 0
var formacao_centro: Node2D = null

func _ready():
	last_trail = animated_rightTrail
	animated_sprite.play("sailRight")
	continue_trail_idle()
	health_bar.max_health = max_health
	health_bar.set_health(current_health)

func _process(delta):
	time_since_last_shot += delta
	var direction = Vector2.ZERO

	if player:
		var target_position = player.global_position

		if formacao_centro and pode_atacar:
			var offset = Vector2(formacao_index * 200, 0)
			target_position += offset.rotated((global_position - player.global_position).angle())

		var to_player = target_position - global_position
		var distance = to_player.length()
		var to_player_normalized = to_player.normalized()

		update_animation(to_player_normalized)

		if pode_atacar:
			if time_since_last_shot >= shoot_cooldown:
				await shoot(to_player_normalized)
				time_since_last_shot = 0.0

			if distance > follow_distance:
				direction = to_player_normalized

	if direction.length() > 0:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		continue_trail_idle()

	move_and_slide()

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
