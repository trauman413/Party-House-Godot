extends Node

@onready var door: Button = $Door
@onready var house_grid: GridContainer = $HouseGrid
@onready var party_controller: Node = $PartyController
@onready var cat: Sprite2D = $Cat/Sprite2D
@onready var currency_ui: VBoxContainer = $CurrencyUI
@onready var population_label: Label = $CurrencyUI/PopulationLabel
@onready var money_label: Label = $CurrencyUI/MoneyLabel
@onready var turn_label: Label = $CurrencyUI/TurnLabel


@export var start_pos: Vector2 = Vector2(218, 136)
@export var x_diff: int = 150
@export var y_diff: int = 150
@export var edge: int = 1000

@export_group("Guest Types")
@export var hippie: PackedScene
@export var old_friend: PackedScene
@export var rich_pal: PackedScene
@export var wild_buddy: PackedScene
@export var monkey: PackedScene
@export var auctioneer: PackedScene
@export var caterer: PackedScene

var curr_pos = start_pos
var curr_house_members = 0
var global_trouble = 0
var party_state: Constants.PartyState
var guest_deck = []
var global_population: int
var global_money: int
var current_turn: int

signal end_turn
signal completed_round(new_money: int, new_population: int)

func _ready() -> void:
	party_state = Constants.PartyState.NORMAL
	end_turn.connect(on_end_turn)
	population_label.text = "POP: " + str(global_population)
	money_label.text = "MONEY: " + str(global_money)
	turn_label.text = "TURN: " + str(current_turn)
	
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("end_turn"):
		end_turn.emit()

func set_guest_deck(
	guest_dict: Dictionary[Guest_Type, int]
):
	var deck = quantity_dict_to_list(guest_dict)
	deck.shuffle()
	guest_deck = deck
	
func quantity_dict_to_list(
	dict: Dictionary[Guest_Type,int]
) -> Array[Guest_Type]:
	var lst: Array[Guest_Type] = []
	for key in dict:
		for quantity in range(dict[key]):
			lst.append(key)
	return lst

func _on_door_pressed() -> void:
	# todo: need to test use case of trouble, trouble then hippie
	if curr_house_members < party_controller.house_size:
		var new_guest = create_guest()
		house_grid.add_child(new_guest)
		curr_house_members += 1
		new_guest.position = curr_pos
		curr_pos.x += x_diff
		if curr_pos.x > edge:
			curr_pos.x = start_pos.x
			curr_pos.y += y_diff
		global_trouble += new_guest.trouble
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
		#await get_tree().create_timer(0.5).timeout
		completed_round.emit(0, 0)
		#get_tree().quit()
	if (curr_house_members == party_controller.house_size):
		print("END TURN")
		print("=======")
		end_turn.emit()

func create_guest():
	var first_guest = guest_deck.pop_front()
	var guest_to_node = get_first_guest_node(first_guest)
	var new_guest: Guest = guest_to_node.instantiate()
	#new_guest.play()
	#new_guest.set_guest_type(first_guest)
	return new_guest
	
func get_first_guest_node(guest_type: Guest_Type) -> PackedScene:
	print(guest_type.id)
	var guest: PackedScene
	match guest_type.id:
		"hippie": guest = hippie
		"old_friend": guest = old_friend
		"rich_pal": guest = rich_pal
		"wild_buddy": guest = wild_buddy
		"monkey": guest = monkey
		"auctioneer": guest = auctioneer
		"caterer": guest = caterer
		_: guest = null
	return guest
		

func on_end_turn() -> void:
	# TODO: change to calculate game state
	var calc_population = 0
	var calc_money = 0
	var trouble = 0
	for guest_type: Guest in house_grid.get_children():
		calc_money += guest_type.money
		calc_population += guest_type.population
		trouble += guest_type.trouble
	print("Population: " + str(calc_population))
	print("Money: " + str(calc_money))
	print("Trouble: " + str(trouble))
	door.disabled = true
	completed_round.emit(calc_money, calc_population)
	#await get_tree().create_timer(0.5).timeout
	#get_tree().quit()
