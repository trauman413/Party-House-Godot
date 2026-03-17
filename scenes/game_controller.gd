extends Node

@export var guest_pool: Array[Guest_Type]
var party_scene = preload("res://scenes/party.tscn")
var purchase_scene = preload("res://scenes/purchase.tscn")

var party: Node
var purchase: Node

func reload_party_scene() -> void:
	print(GameState.get_guest_deck())
	party = party_scene.instantiate()
	get_parent().add_child.call_deferred((party))
	party.completed_round.connect(_on_party_completed_round)
	party.global_population = GameState.get_global_population()
	party.global_money = GameState.get_global_money()
	party.current_turn = GameState.get_turn_count()
	var guest_dict = get_guest_type_dict()
	party.set_guest_deck(guest_dict)
	
func load_purchase_scene() -> void:
	purchase = purchase_scene.instantiate()
	get_parent().add_child.call_deferred((purchase))
	purchase.make_purchase.connect(_on_make_purchase)
	purchase.end_round.connect(_on_end_button_pressed)
	purchase.global_population = GameState.get_global_population()
	purchase.global_money = GameState.get_global_money()
	purchase.current_turn = GameState.get_turn_count()

func _ready() -> void:
	reload_party_scene()
	
func get_guest_type_dict() -> Dictionary[Guest_Type, int]:
	var dict: Dictionary[Guest_Type, int] = {}
	var guest_deck: Dictionary[String, int] = GameState.get_guest_deck()
	for guest_type in guest_pool:
		dict[guest_type] = guest_deck[guest_type.id]
	return dict

func _on_party_completed_round(new_money: int, new_population: int) -> void:
	GameState.set_global_money(new_money)
	GameState.set_global_population(new_population)
	print("========GLOBAL CALCS=========")
	print("GLOBAL MONEY: " + str(GameState.get_global_money()))
	print("GLOBAL POP: " + str(GameState.get_global_population()))
	await get_tree().create_timer(0.5).timeout
	get_parent().remove_child(party)
	party.queue_free()
	GameState.decrement_turns()
	load_purchase_scene()
	#reload_party_scene()


func _on_game_over() -> void:
	print("GAME OVER, YOU LOSE")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
	

func _on_make_purchase(
	guest_id: String,
	cost_pop: int,
	cost_money: int
):
	if cost_pop > GameState.get_global_population():
		print("Cannot purchase, too expensive")
	else:
		GameState.update_guests(guest_id)
		GameState.set_global_population((-1 * cost_pop))
		GameState.set_global_money((-1 * cost_money))
		purchase.global_population = GameState.get_global_population()
		purchase.global_money = GameState.get_global_money()
		purchase.current_turn = GameState.get_turn_count()
	# todo: will need to change below to only end when clicking "END" button
	
func _on_end_button_pressed():
	print("QUEUE FREEEEE")
	get_parent().remove_child(purchase)
	#purchase.queue_free()
	reload_party_scene()
