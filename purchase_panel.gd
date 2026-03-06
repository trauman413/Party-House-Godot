extends PanelContainer
class_name PurchasePanel

@export var guest_scene: PackedScene
@onready var guest_container: PanelContainer = %GuestContainer
@onready var name_label: Label = %NameLabel
@onready var money_label: Label = %MoneyLabel
@onready var population_label: Label = %PopulationLabel
@onready var ability_label: Label = %AbilityLabel

var guest: Guest

signal purchased(guest: Guest)

func _ready() -> void:
	guest = guest_scene.instantiate()
	guest.position = Vector2(100,100)
	guest_container.add_child(guest)
	name_label.text = guest.display_name
	money_label.text = str(guest.money)
	population_label.text = str(guest.population)
	#ability_label.text = guest.ability_description
	# TODO: account for number that can be bought

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("Buying " + guest.display_name)
		purchased.emit(guest.id, 1, 1) # TODO: change to be static field on json
