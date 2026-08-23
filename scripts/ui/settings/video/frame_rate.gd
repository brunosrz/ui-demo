extends HBoxContainer

@onready var option_button: OptionButton = $FrameRateLimitOptionButton
@onready var frame_rate_limit_label: Label = $FrameRateLimitLabel


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	frame_rate_limit_label.mouse_entered.connect(
		_on_mouse_entered_control.bind(frame_rate_limit_label)
	)
	frame_rate_limit_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_frame_rate_limit_option_button_item_selected(index: int) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"frame_rate_limit_mode": index}})


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("frame_rate_limit_mode"):
		option_button.select(settings["frame_rate_limit_mode"])


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
