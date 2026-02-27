extends Guest

@export var metadata: Guest_Type
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super.initialize_metadata(metadata)
	play()
	
func play():
	animation.play()
