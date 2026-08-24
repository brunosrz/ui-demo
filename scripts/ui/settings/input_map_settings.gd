extends VBoxContainer

@onready var input_actions_container: VBoxContainer = $ScrollContainer/InputActionsContainer
@onready var reset_button: Button = $ResetButton


func _ready() -> void:
	GlobalEvents.loading_input_map_changed.connect(_update_ui)
	reset_button.pressed.connect(_on_reset_button_pressed)

	GlobalEvents.request_loading_input_map_changed.emit()


func _update_ui(input_map_data: Dictionary) -> void:
	for child in input_actions_container.get_children():
		if child.name != "Header" and child.name != "HSeparator":
			child.queue_free()

	for category_key in input_map_data:
		var category_label = Label.new()
		category_label.text = tr("UI_INPUT_CATEGORY_" + category_key.to_upper())
		category_label.add_theme_font_size_override("font_size", 24)
		category_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		input_actions_container.add_child(category_label)

		for action_key in input_map_data[category_key]:
			var input_row = (
				preload("res://scenes/ui/settings/input_row_template.tscn").instantiate()
			)
			input_actions_container.add_child(input_row)
			input_row.set_action_name(action_key)
			input_row.update_bindings(input_map_data[category_key][action_key])
			input_row.remap_requested.connect(_on_remap_requested.bind(category_key))


func _on_reset_button_pressed() -> void:
	GlobalEvents.request_reset_input_map.emit()


func _on_remap_requested(action: String, input_type: String, category: String) -> void:
	print("Remapear: ", category, ".", action, " (", input_type, ")")
