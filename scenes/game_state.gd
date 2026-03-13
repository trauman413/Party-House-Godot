extends Node

enum PHASES { PARTY, PURCHASE }

# todo: hippie isn't in starting deck
var global_guests: Dictionary[String, int] = {
	"old_friend": 4,
	"rich_pal": 2,
	"wild_buddy": 4,
	"hippie": 0
} 
var global_money = 0
var global_population = 0
var turns_remaining = 40
var house_size = 5

signal game_over

func set_global_money(new_money: int):
	global_money += new_money

func set_global_population(new_pop: int):
	global_population += new_pop
	
func update_guests(guestId: String):
	print("hiya")
	if guestId in global_guests:
		global_guests[guestId] += 1
	else:
		global_guests[guestId] = 1
	
func get_global_money():
	return global_money
	
func get_global_population():
	return global_population
	
func get_guest_deck():
	return global_guests

func decrement_turns():
	turns_remaining -= 1
	if turns_remaining == 0:
		game_over.emit()
	
func get_turn_count():
	return turns_remaining
