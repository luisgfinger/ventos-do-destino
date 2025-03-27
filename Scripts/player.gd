extends CharacterBody2D

@export var speed: float = 100.0

@onready var animated_sprite = $Sail
@onready var animated_leftTrail = $waterLeftAnim
@onready var animated_rightTrail = $waterRightAnim
@onready var animated_upTrail = $waterUpAnim
@onready var animated_downTrail = $waterDownAnim
@onready var animated_upRightTrail = $waterUpRightAnim
@onready var animated_upLeftTrail = $waterUpLeftAnim
@onready var animated_downRightTrail = $waterDownRightAnim
@onready var animated_downLeftTrail = $waterDownLeftAnim

var last_direction: Vector2 = Vector2.DOWN
var last_trail: Node = null

func _ready():
	last_trail = animated_rightTrail
	animated_sprite.play("sailRight")
	continue_trail_idle()

func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

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
