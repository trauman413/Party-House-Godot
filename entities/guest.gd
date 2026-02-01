extends Node2D
class_name Guest

# TODO: may change to dictionary later
@export var guest_pool: Array[Guest_Type]
var guest_type

func _ready() -> void:
	guest_type = generate_guest_type()
	print("Guest is: " + guest_type.display_name)

func generate_guest_type() -> Guest_Type:
	return guest_pool.pick_random()
