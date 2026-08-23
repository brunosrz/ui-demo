extends Control

@onready var label: Label = $Label


func _ready() -> void:
	visible = false


func set_text(text_content: String) -> void:
	label.text = text_content

	size = label.get_minimum_size() + Vector2(10, 10)
