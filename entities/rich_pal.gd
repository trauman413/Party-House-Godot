extends Guest

@export var metadata: Guest_Type

var id: String
var display_name: String
var population: int
var money: int
var trouble: int
var ability_description: String

func _ready() -> void:
	super.initialize_metadata(metadata)
