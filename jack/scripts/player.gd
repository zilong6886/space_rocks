extends Area2D

export var rot_speed = 2.6
export var thrust = 500
export var max_vel = 400
export var friction = 0.65

var screen_size = Vector2.ZERO
var vel = Vector2.ZERO
var acc = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	self.position = screen_size / 2
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("PLAYER_LEFT"):
		rotation -= rot_speed * delta
	if Input.is_action_pressed("PLAYER_RIGHT"):
		rotation += rot_speed * delta	
		
	if Input.is_action_pressed("PLAYER_THRUST"):
		acc = Vector2(thrust, 0).rotated(rotation - PI/2)
	else:
		acc = Vector2.ZERO	
	acc += vel * -friction #Them friction vao de ship cham dan lai
	
	vel += acc * delta
	position += vel * delta
	if position.x > screen_size.x: #Screen wrapping
		position.x = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y > screen_size.y:
		position.y = 0
	if position.y < 0:
		position.y = screen_size.y
		
