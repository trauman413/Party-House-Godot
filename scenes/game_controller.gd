extends Node

@onready var game_state: Node = $"../GameState"
#@onready var party: Node = $"../Party"
var party_scene = preload("res://scenes/party.tscn")

var party: Node

func reload_party_scene() -> void:
	party = party_scene.instantiate()
	get_parent().add_child.call_deferred((party))
	party.completed_round.connect(_on_party_completed_round)

func _ready() -> void:
	reload_party_scene()


func _on_party_completed_round(new_money: int, new_population: int) -> void:
	game_state.set_global_money(new_money)
	game_state.set_global_population(new_population)
	print("========GLOBAL CALCS=========")
	print("GLOBAL MONEY: " + str(game_state.get_global_money()))
	print("GLOBAL POP: " + str(game_state.get_global_population()))
	await get_tree().create_timer(0.5).timeout
	party.queue_free()
	reload_party_scene()
