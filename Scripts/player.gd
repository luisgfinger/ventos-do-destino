extends CharacterBody2D

@export var speed: float = 300.0
@export var max_health: float = 1000.0
@export var projectile_scene: PackedScene
@export var shoot_cooldown: float = 0.0

var current_health: float = max_health
var time_since_last_shot: float = 0.0
var tempo_desde_acao_hostil: float = 0.0
var tempo_para_curar: float = 5.0
var taxa_regeneracao: int = 5

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
	last_trail = animated_downRightTrail
	animated_sprite.play("sailDownRight")
	continue_trail_idle()
	health_bar.max_health = max_health
	health_bar.set_health(current_health)

func _process(delta):
	
	time_since_last_shot += delta
	tempo_desde_acao_hostil += delta

	if tempo_desde_acao_hostil >= tempo_para_curar and current_health < max_health:
		curar(delta)

	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("mouse_left_click") and time_since_last_shot >= shoot_cooldown:
		var mouse_pos = get_global_mouse_position()
		await shoot(mouse_pos)
		time_since_last_shot = 0.0
		tempo_desde_acao_hostil = 0.0

	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * speed
		update_animation(direction)
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
	tempo_desde_acao_hostil = 0.0
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_bar.set_health(current_health)

	if current_health <= 0:
		die()

func die():
	print("Player morreu!")
	get_tree().quit()

func shoot(target_position: Vector2) -> void:
	if not projectile_scene:
		return

	tempo_desde_acao_hostil = 0.0

	var direction = (target_position - global_position).normalized()
	
	var number_of_cannons = GameData.cannon
	var number_of_crew = GameData.crew

	var cannons_to_fire = min(number_of_cannons, number_of_crew)

	if cannons_to_fire <= 0:
		print("Sem tripulantes suficientes para disparar.")
		return

	for i in range(cannons_to_fire):
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.direction = direction
		get_tree().current_scene.add_child(projectile)

		if i < cannons_to_fire - 1:
			await get_tree().create_timer(0.1).timeout

	if cooldown_ui:
		cooldown_ui.start(shoot_cooldown)

func curar(delta: float):
	var cura = taxa_regeneracao * delta
	current_health = clamp(current_health + cura, 0, max_health)
	health_bar.set_health(current_health)
