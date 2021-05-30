extends Node2D

var asteroid = preload("res://scenes/asteroid.tscn")
onready var spawns = $spawn_locations

func _ready():
	for i in range(5):
		var a = asteroid.instance()
		add_child(a)
		a.init("big", spawns.get_child(i).position)
