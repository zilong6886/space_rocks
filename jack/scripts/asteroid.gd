extends KinematicBody2D

export var bounce = 1.1
onready var puff = $puff

signal explode

var size
var vel = Vector2()
var rot_speed
var extents
var screen_size
var textures = {
	'big':[
		'res://assets/art/sheet.meteorGrey_big1.atlastex',
		'res://assets/art/sheet.meteorGrey_big2.atlastex',
		'res://assets/art/sheet.meteorGrey_big3.atlastex',
		'res://assets/art/sheet.meteorGrey_big4.atlastex',
	],
	'med':[
		'res://assets/art/sheet.meteorGrey_med1.atlastex',
		'res://assets/art/sheet.meteorGrey_med2.atlastex',
	],
	'sm':[
		'res://assets/art/sheet.meteorGrey_small1.atlastex',
		'res://assets/art/sheet.meteorGrey_small2.atlastex',
	],
	'tiny':[
		'res://assets/art/sheet.meteorGrey_tiny1.atlastex',
		'res://assets/art/sheet.meteorGrey_tiny2.atlastex',
	]
}

func _ready():
	add_to_group("asteroids")
	randomize()
	set_physics_process(true)
	
	screen_size = get_viewport_rect().size	

func init(init_size, init_pos, init_vel):
	size = init_size
	
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2 * PI))
	
	rot_speed = rand_range(-1.5, 1.5)
	
	var texture = load(textures[size][randi() % textures[size].size()])
	$sprite.set_texture(texture)
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	shape.radius = min(texture.get_width() / 2, texture.get_height() / 2)
	var collision = CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)
	position = init_pos
	
func _physics_process(delta):
	vel = vel.clamped(300)
	rotation = rotation + rot_speed * delta
	var collision = move_and_collide(vel * delta)
	
	# Bounce back when collide other asteroids
	if collision != null:
		vel += collision.normal * collision.collider_velocity.length() * bounce
		puff.global_position = collision.position
		puff.emitting = true
	
	#wrap around screen edges
	if position.x > screen_size.x + extents.x:
		position.x = -extents.x
	if position.x < -extents.x:
		position.x = screen_size.x + extents.x
	if position.y > screen_size.y + extents.y:
		position.y = -extents.y
	if position.y < -extents.y:
		position.y = screen_size.y + extents.y
		
func explode(hit_vel):
	emit_signal("explode", size, position, vel, hit_vel)
	globals.score += globals.ast_score[size]
	queue_free()	
