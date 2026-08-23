extends PanelContainer

@onready var text_label: Label = $VBoxContainer/TextLabel
@onready var next_button: Button = $VBoxContainer/HBoxContainer/NextButton
@onready var skip_button: Button = $VBoxContainer/HBoxContainer/SkipButton


func setup_coach_mark(text: String, show_skip: bool = true) -> void:
	text_label.text = text
	skip_button.visible = show_skip
	visible = true


func hide_coach_mark() -> void:
	visible = false


func _on_next_button_pressed() -> void:
	GlobalEvents.emit_signal("coach_mark_next_requested")


func _on_skip_button_pressed() -> void:
	GlobalEvents.emit_signal("coach_mark_skip_requested")
