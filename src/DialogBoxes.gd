extends Node2D

var initial_offset := Vector2()

func _ready():
	initial_offset = position
	DialogManager.connect("new_message", self, "_on_new_message")

func _process(delta):
	var vertical_offset := 0.0
	for c in $VBoxContainer.get_children():
		vertical_offset += c.rect_size.y + 20.0
	position = initial_offset - Vector2(0.0, vertical_offset)

func _on_new_message(on_left_side: bool, text: String):
	var cur_dialog_box: HBoxContainer = preload("res://DialogBox.tscn").instance()
	$VBoxContainer.add_child(cur_dialog_box)
	cur_dialog_box.text = text
	cur_dialog_box.left_justified = on_left_side
	cur_dialog_box.type_text()
