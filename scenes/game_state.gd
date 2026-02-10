extends Node

enum PHASES { PARTY, PURCHASE }

var global_money = 0
var global_population = 0



func _on_party_completed_round(new_money: int, new_population: int) -> void:
	global_money += new_money
	global_population += new_population
