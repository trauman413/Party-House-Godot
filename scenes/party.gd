extends Node

@onready var door: Button = $Door
@export var guest: PackedScene

var next_pos = Vector2(150,100)
	

func _on_door_pressed() -> void:
	var new_guest = guest.instantiate()
	add_child(new_guest)
	new_guest.position = next_pos
	next_pos.x += 150
