extends Node

@onready var door: Button = $Door
@onready var house_grid: GridContainer = $HouseGrid
@onready var party_controller: Node = $PartyController
@onready var cat: Sprite2D = $Cat/Sprite2D

@export var guest_data: PackedScene
@export var start_pos: Vector2 = Vector2(218, 136)
@export var x_diff: int = 150
@export var y_diff: int = 150
@export var edge: int = 1000

var curr_pos = start_pos
var curr_house_members = 0
var global_trouble = 0
var party_state: Constants.PartyState

signal end_turn
signal completed_round(new_money: int, new_population: int)

func _ready() -> void:
	party_state = Constants.PartyState.NORMAL
	end_turn.connect(on_end_turn)

func _on_door_pressed() -> void:
	# todo: need to test use case of trouble, trouble then hippie
	if curr_house_members < party_controller.house_size:
		var new_guest = guest_data.instantiate()
		house_grid.add_child(new_guest)
		curr_house_members += 1
		new_guest.position = curr_pos
		curr_pos.x += x_diff
		if curr_pos.x > edge:
			curr_pos.x = start_pos.x
			curr_pos.y += y_diff
		global_trouble += new_guest.guest_type.trouble
	if global_trouble == 2 && party_state != Constants.PartyState.WARNING:
		party_state = Constants.PartyState.WARNING
		cat.modulate = Color(0.831, 0.0, 0.0, 1.0)
	elif global_trouble < 2:
		party_state = Constants.PartyState.NORMAL
		cat.modulate = Color(1,1,1,1.0)
	if global_trouble >= 3:
		party_state = Constants.PartyState.LOSE
		door.disabled = true
		print("Too rowdy, police showed up and ended party")
		await get_tree().create_timer(0.5).timeout
		completed_round.emit(0, 0)
		get_tree().quit()
	if (curr_house_members == party_controller.house_size):
		print("END TURN")
		print("=======")
		end_turn.emit()

func on_end_turn() -> void:
	# TODO: change to calculate game state
	var calc_population = 0
	var calc_money = 0
	var trouble = 0
	for guest_type: Guest in house_grid.get_children():
		calc_money += guest_type.guest_type.money
		calc_population += guest_type.guest_type.population
		trouble += guest_type.guest_type.trouble
	print("Population: " + str(calc_population))
	print("Money: " + str(calc_money))
	print("Trouble: " + str(trouble))
	door.disabled = true
	completed_round.emit(calc_money, calc_population)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
