extends VBoxContainer

var _pending_rebind: Dictionary = {}

@onready var input_actions_container: VBoxContainer = $ScrollContainer/InputActionsContainer
@onready var reset_button: Button = $ResetButton


func _ready() -> void:
	GlobalEvents.loading_input_map_changed.connect(_update_ui)
	reset_button.pressed.connect(_on_reset_button_pressed)

	GlobalEvents.request_loading_input_map_changed.emit()


func _update_ui(input_map_data: Dictionary) -> void:
	_pending_rebind = {}

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
			input_row.remap_requested.connect(_on_remap_requested.bind(input_row))


func _on_reset_button_pressed() -> void:
	GlobalEvents.request_reset_input_map.emit()


func _on_remap_requested(action: String, input_type: String, row: Node) -> void:
	if not _pending_rebind.is_empty():
		return

	row.set_listening(input_type)
	_pending_rebind = {"action": action, "input_type": input_type}


func _unhandled_input(event: InputEvent) -> void:
	if _pending_rebind.is_empty():
		return

	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_RIGHT
		and event.pressed
	):
		get_viewport().set_input_as_handled()
		_cancel_pending_rebind()
		return

	var input_type: String = _pending_rebind["input_type"]
	var captured_event: InputEvent = null

	match input_type:
		"keyboard":
			if event is InputEventKey and event.pressed and not event.echo:
				captured_event = event
		"controller":
			if event is InputEventJoypadButton and event.pressed:
				captured_event = event
		"mouse":
			if event is InputEventMouseButton and event.pressed:
				captured_event = event

	if captured_event == null:
		return

	get_viewport().set_input_as_handled()

	var action: String = _pending_rebind["action"]
	_pending_rebind = {}
	SettingsManager.rebind_action(action, input_type, captured_event)


func _cancel_pending_rebind() -> void:
	_pending_rebind = {}
	GlobalEvents.request_loading_input_map_changed.emit()
