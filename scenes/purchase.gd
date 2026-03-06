extends Node

@onready var population_label: Label = $CurrencyUI/PopulationLabel
@onready var turn_label: Label = $CurrencyUI/TurnLabel
@onready var money_label: Label = $CurrencyUI/MoneyLabel
@onready var grid_container: GridContainer = $GridContainer

var global_population: int
var global_money: int
var current_turn: int

signal finished_purchase(guest: String, cost_pop: int, cost_money: int)


func _ready() -> void:
	population_label.text = "POP: " + str(global_population)
	money_label.text = "MONEY: " + str(global_money)
	turn_label.text = "TURN: " + str(current_turn)
	for child: PurchasePanel in grid_container.get_children():
		child.purchased.connect(_on_card_clicked)
		

func _on_card_clicked(guest_id: String, cost_pop: int, cost_money: int):
	finished_purchase.emit(guest_id, cost_pop, cost_money)
