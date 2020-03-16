tool
extends HBoxContainer

var text := "Hello! My name is sandra. I'd like to check in for security"

export var left_justified := true setget set_left_justified
var cur_text_position := 0
onready var label: Label = $PanelContainer/MarginContainer/DialogLabel
onready var type_timer = $TypeTimer

func _ready():
	if not Engine.editor_hint:
		type_text()

func set_left_justified(new_left_justified: bool):
	left_justified = new_left_justified
	if label != null:
		
		if left_justified:
			move_child($Spacer, 1)
			label.align = Label.ALIGN_LEFT
		else:
			move_child($Spacer, 0)
			label.align = Label.ALIGN_RIGHT

func type_text():
	label.text = ""
	rect_size.y = 0.0
	cur_text_position = 0
	type_timer.start()


func _on_TypeTimer_timeout():
	cur_text_position += 1
	if cur_text_position > text.length():
		type_timer.stop()
	label.text = text.left(cur_text_position)
	rect_size.y = 0.0
