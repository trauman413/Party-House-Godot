extends Node2D
class_name Guest

@export var guest_type: Guest_Type

func _ready() -> void:
	print(guest_type.population)
