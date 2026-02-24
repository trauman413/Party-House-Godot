extends Node2D
class_name Guest

var guest_type: Guest_Type
var id: String
var display_name: String
var population: int
var money: int
var trouble: int
var ability_description: String

func _ready() -> void:
	print("Guest is: " + guest_type.display_name)
	
func set_guest_type(type: Guest_Type):
	guest_type = type

func initialize_metadata(metadata: Guest_Type):
	id = metadata.id
	display_name = metadata.display_name
	population = metadata.population
	money = metadata.money
	trouble = metadata.trouble
	ability_description = metadata.ability_description
