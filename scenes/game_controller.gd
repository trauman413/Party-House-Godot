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
	var guest_dict = get_guest_type_dict()
	party.set_guest_deck(guest_dict)
	
func load_purchase_scene() -> void:
	purchase = purchase_scene.instantiate()
	get_parent().add_child.call_deferred((purchase))

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
	reload_party_scene()
