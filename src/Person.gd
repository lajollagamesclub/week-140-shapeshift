extends Node2D

const possible_body_types = [
	"fat",
	"missed leg day",
	"too normal"
]
const possible_head_types = [
	"nerd",
	"creepily young",
	"inhuman",
	"scary"
]

var attributes = []

func _ready():
	randomize()
	attributes.append(possible_body_types[randi()%possible_body_types.size()])
	attributes.append(possible_head_types[randi()%possible_head_types.size()])
