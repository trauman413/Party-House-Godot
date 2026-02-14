extends Node

enum PHASES { PARTY, PURCHASE }

var global_money = 0
var global_population = 0
var guest_deck: Array[Guest_Type] = []

func set_global_money(new_money: int):
	global_money += new_money

func set_global_population(new_pop: int):
	global_population += new_pop
	
func get_global_money():
	return global_money
	
func get_global_population():
	return global_population
