extends PanelContainer
class_name PurchasePanel

@export var guest_scene: PackedScene
@onready var guest_container: PanelContainer = %GuestContainer
@onready var name_label: Label = %NameLabel
@onready var money_label: Label = %MoneyLabel
@onready var population_label: Label = %PopulationLabel
@onready var ability_label: Label = %AbilityLabel
@onready var cost_label: Label = %CostLabel

var guest: Guest

signal purchased(guest: Guest)

func _ready() -> void:
	guest = guest_scene.instantiate()
	guest.position = Vector2(100,100)
	guest_container.add_child(guest)
	name_label.text = guest.display_name
	money_label.text = str(guest.money)
	population_label.text = str(guest.population)
	cost_label.text = str("Cost: " + str(guest.cost))
	#ability_label.text = guest.ability_description
	# TODO: account for number that can be bought

# TODO: can refactor to just call GameState directly
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		self.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		print("Buying " + guest.display_name)
		purchased.emit(guest.id, guest.cost, 0) # TODO: change to be static field on json
