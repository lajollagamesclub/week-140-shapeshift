extends Node

signal new_message(on_left_side, text)

func send_message(on_left_side: bool, text: String):
	emit_signal("new_message", on_left_side, text)
