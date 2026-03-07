extends Node

@onready var game_state: Node = $"../GameState"
@export var guest_pool: Array[Guest_Type]
var party_scene = preload("res://scenes/party.tscn")
var purchase_scene = preload("res://scenes/purchase.tscn")

var party: Node
var purchase: Node

func reload_party_scene() -> void:
	party = party_scene.instantiate()
	get_parent().add_child.call_deferred((party))
	party.completed_round.connect(_on_party_completed_round)
	party.global_population = game_state.get_global_population()
	party.global_money = game_state.get_global_money()
	party.current_turn = game_state.get_turn_count()
	var guest_dict = get_guest_type_dict()
	party.set_guest_deck(guest_dict)
	
func load_purchase_scene() -> void:
	purchase = purchase_scene.instantiate()
	get_parent().add_child.call_deferred((purchase))
	purchase.finished_purchase.connect(_on_purchase_completed_round)
	purchase.global_population = game_state.get_global_population()
	purchase.global_money = game_state.get_global_money()
	purchase.current_turn = game_state.get_turn_count()

func _ready() -> void:
	reload_party_scene()
	
func get_guest_type_dict() -> Dictionary[Guest_Type, int]:
	var dict: Dictionary[Guest_Type, int] = {}
	var guest_deck: Dictionary[String, int] = game_state.get_guest_deck()
	for guest_type in guest_pool:
		dict[guest_type] = guest_deck[guest_type.id]
	return dict

func _on_party_completed_round(new_money: int, new_population: int) -> void:
	game_state.set_global_money(new_money)
	game_state.set_global_population(new_population)
	print("========GLOBAL CALCS=========")
	print("GLOBAL MONEY: " + str(game_state.get_global_money()))
	print("GLOBAL POP: " + str(game_state.get_global_population()))
	await get_tree().create_timer(0.5).timeout
	party.queue_free()
	game_state.decrement_turns()
	load_purchase_scene()
	#reload_party_scene()


func _on_game_over() -> void:
	print("GAME OVER, YOU LOSE")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
	

func _on_purchase_completed_round(
	guest_id: String,
	cost_pop: int,
	cost_money: int
):
	if cost_pop > game_state.get_global_population():
		print("Cannot purchase, too expensive")
	else:
		game_state.update_guests(guest_id)
		game_state.set_global_population((-1 * cost_pop))
		game_state.set_global_money((-1 * cost_money))
	# todo: will need to change below to only end when clicking "END" button
	await get_tree().create_timer(0.5).timeout
	purchase.queue_free()
	reload_party_scene()
