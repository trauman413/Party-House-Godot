extends Node

@onready var door: Button = $Door
@onready var house_grid: GridContainer = $HouseGrid
@export var guest: PackedScene
@export var start_pos: Vector2 = Vector2(218, 68)
@export var x_diff: int = 150
@export var y_diff: int = 150
@export var edge: int = 1000

var curr_pos = start_pos

func _ready() -> void:
	print(door.size)
	

func _on_door_pressed() -> void:
	print(curr_pos)
	var new_guest = guest.instantiate()
	house_grid.add_child(new_guest)
	#add_child(new_guest)
	new_guest.position = curr_pos
	curr_pos.x += x_diff
	if curr_pos.x > edge:
		curr_pos.x = start_pos.x
		curr_pos.y += y_diff
