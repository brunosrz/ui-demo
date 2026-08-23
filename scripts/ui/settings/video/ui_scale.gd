extends HBoxContainer

@onready var option_button: OptionButton = $UIScaleOptionButton
@onready var ui_scale_label: Label = $UIScaleLabel


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	ui_scale_label.mouse_entered.connect(_on_mouse_entered_control.bind(ui_scale_label))
	ui_scale_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_ui_scale_option_button_item_selected(index: int) -> void:
	var ui_scale_value: float
	match index:
		0:
			ui_scale_value = 1.0
		1:
			ui_scale_value = 1.25
		2:
			ui_scale_value = 1.5
		3:
			ui_scale_value = 1.75
		4:
			ui_scale_value = 2.0
		_:
			ui_scale_value = 1.0

	GlobalEvents.setting_changed.emit({"video": {"ui_scale": ui_scale_value}})


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings["video"].has("ui_scale"):
		var ui_scale_value: float = settings["video"]["ui_scale"]
		var selected_index: int = -1
		match ui_scale_value:
			1.0:
				selected_index = 0
			1.25:
				selected_index = 1
			1.5:
				selected_index = 2
			1.75:
				selected_index = 3
			2.0:
				selected_index = 4

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
