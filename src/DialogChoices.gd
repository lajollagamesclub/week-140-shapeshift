extends HBoxContainer

var choices := [
	"Hello there!",
	"What's up??",
	"Nothing much..",
	"Bruh"
]

var on_left_side := true

func _ready():
	update_choices()

func update_choices():
	for c in get_children():
		c.queue_free()
	for choice in choices:
		var cur_dialog_choice: Button = preload("res://DialogChoice.tscn").instance()
		add_child(cur_dialog_choice)
		cur_dialog_choice.text = choice
		cur_dialog_choice.connect("pressed", self, "_choice_chosen", [choice])

func _choice_chosen(text: String):
	on_left_side = not on_left_side
	DialogManager.send_message(on_left_side, text)
