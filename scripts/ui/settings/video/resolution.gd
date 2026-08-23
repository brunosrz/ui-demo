extends HBoxContainer

@onready var option_button: OptionButton = $ResolutionOptionButton
@onready var resolution_label: Label = $ResolutionLabel

const RESOLUTION_MAP: Dictionary = {
	1: Vector2i(640, 360),
	2: Vector2i(854, 480),
	3: Vector2i(1280, 720),
	4: Vector2i(1920, 1080),
	5: Vector2i(2560, 1440),
	6: Vector2i(3840, 2160)
}


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	resolution_label.mouse_entered.connect(_on_mouse_entered_control.bind(resolution_label))
	resolution_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_resolution_option_button_item_selected(index: int) -> void:
	if RESOLUTION_MAP.has(index):
		GlobalEvents.emit_signal(
			"setting_changed", {"video": {"resolution": RESOLUTION_MAP[index]}}
		)


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings["video"].has("resolution"):
		var current_resolution: Vector2i = Vector2i(
			settings["video"]["resolution"].x, settings["video"]["resolution"].y
		)
		var selected_index: int = -1
		for key in RESOLUTION_MAP:
			if RESOLUTION_MAP[key] == current_resolution:
				selected_index = key
				break

		if selected_index != -1 and option_button.selected != selected_index:
			option_button.select(selected_index)


func _on_mouse_entered_control(control_node: Control) -> void:
	@warning_ignore("shadowed_variable_base_class")
	var tooltip_text: String = ""
	if control_node and control_node.has_meta("tooltip_text"):
		tooltip_text = control_node.get_meta("tooltip_text")
	elif control_node and control_node.tooltip_text:
		tooltip_text = tr(control_node.tooltip_text)

	if not tooltip_text.is_empty():
		GlobalEvents.show_tooltip_requested.emit(
			{"text": tooltip_text, "position": get_global_mouse_position()}
		)


func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
