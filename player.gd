extends CharacterBody2D

@export var wheel_base = 70  # Distance from front to rear wheel
@export var steering_angle = 45.0  # Amount that front wheel turns, in degrees
@export var velocity_travel: Vector2 = Vector2.ZERO
var steer_angle
@export var engine_power = 15000
@export var acceleration: Vector2 = Vector2.ZERO
@export var friction = -0.9
@export var drag = -0.0015
@export var braking = -450
@export var max_speed_reverse = 10000
@export var slip_speed = 400  # Speed where traction is reduced

@export var traction_fast = 0.1  # High-speed traction
@export var traction_slow = 0.7  # Low-speed traction

func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_angle = turn * deg_to_rad(steering_angle)
	
	if Input.is_action_pressed("stop"):
		acceleration = transform.x * braking

	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	
		if Input.is_action_just_pressed("boost"):
			print('boost')
			velocity += transform.x * 100

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * max_speed_reverse
	rotation = new_heading.angle()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func _physics_process(delta):
	get_input()
	apply_friction()
	calculate_steering(delta)
	
	velocity = acceleration * delta
	move_and_slide()
