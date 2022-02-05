extends Control

var stamina = 3 setget set_stamina
var max_stamina= 3 setget set_max_stamina

#onready var label = $Label
onready var staUIFull = $StaUIFull
onready var staUIEmpty = $StaUIEmpty

func set_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	#if label != null:
	#	label.text = "HP = " + str(hearts)
	if staUIFull != null:
		staUIFull.rect_size.x = stamina * 15
	
func set_max_stamina(value):
	max_stamina = max(value, 1)
	self.stamina = min(stamina, max_stamina)
	if staUIEmpty != null:
		staUIEmpty.rect_size.x = max_stamina * 15
	
func _ready():
	self.max_stamina = PlayerStats.max_stamina
	self.stamina = PlayerStats.stamina
	PlayerStats.connect("stamina_changed", self, "set_stamina")
	PlayerStats.connect("max_stamina_changed", self, "set_max_stamina")
