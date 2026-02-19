extends Node2D
class_name Guest

# TODO: may change to dictionary later
#@export var guest_pool: Array[Guest_Type]
var guest_type: Guest_Type

func _ready() -> void:
	print("Guest is: " + guest_type.display_name)

#func generate_guest_type() -> Guest_Type:
	#return guest_pool.pick_random()
	
func set_guest_type(type: Guest_Type):
	guest_type = type
