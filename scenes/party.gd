extends Node

@onready var door: Button = $Door
@onready var house_grid: GridContainer = $HouseGrid
@onready var party_controller: Node = $PartyController

@export var guest: PackedScene
@export var start_pos: Vector2 = Vector2(218, 136)
@export var x_diff: int = 150
@export var y_diff: int = 150
@export var edge: int = 1000

var curr_pos = start_pos
var curr_house_members = 0
	

func _on_door_pressed() -> void:
	if curr_house_members < party_controller.house_size:
		var new_guest = guest.instantiate()
		house_grid.add_child(new_guest)
		curr_house_members += 1
		new_guest.position = curr_pos
		curr_pos.x += x_diff
		if curr_pos.x > edge:
			curr_pos.x = start_pos.x
			curr_pos.y += y_diff
