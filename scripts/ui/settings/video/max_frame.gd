extends HBoxContainer

@onready var slider: HSlider = $MaxFrameRateSlider
@onready var max_frame_rate_label: Label = $MaxFrameRateLabel
@onready var value_label: Label = $MaxFrameRateValueLabel


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	max_frame_rate_label.mouse_entered.connect(_on_mouse_entered_control.bind(max_frame_rate_label))
	max_frame_rate_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)

	slider.value_changed.connect(_on_slider_value_changed)
	_update_value_label(int(slider.value))


func _on_slider_value_changed(value: float) -> void:
	_update_value_label(int(value))
	GlobalEvents.emit_signal("setting_changed", {"video": {"max_frame_rate": int(value)}})


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("max_frame_rate"):
		slider.value = settings.video.max_frame_rate
		_update_value_label(int(slider.value))


func _update_value_label(value: int) -> void:
	value_label.text = str(value)


func _update_ui(video_settings: Dictionary) -> void:
	if video_settings.has("max_frame_rate"):
		slider.value = video_settings.max_frame_rate
		_update_value_label(int(slider.value))


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
