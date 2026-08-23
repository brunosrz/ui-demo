extends HBoxContainer

@onready var slider: HSlider = $MasterSlider
@onready var master_label: Label = $MasterLabel
@onready var value_label: Label = $MasterValueLabel


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	master_label.mouse_entered.connect(_on_mouse_entered_control.bind(master_label))
	master_label.mouse_exited.connect(_on_mouse_exited_control)
	slider.mouse_entered.connect(_on_mouse_entered_control.bind(slider))
	slider.mouse_exited.connect(_on_mouse_exited_control)

	slider.value_changed.connect(_on_slider_value_changed)
	_update_value_label(slider.value)


func _on_slider_value_changed(value: float) -> void:
	_update_value_label(value)
	GlobalEvents.emit_signal("setting_changed", {"audio": {"master_volume": value}})


func _on_master_slider_drag_ended(_value_changed: bool) -> void:
	pass


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("audio") and settings.audio.has("master_volume"):
		slider.value = settings.audio.master_volume
		_update_value_label(slider.value)


func _update_value_label(value: float) -> void:
	value_label.text = str(int(value * 100)) + "%"


func _update_ui(audio_settings: Dictionary) -> void:
	if audio_settings.has("master_volume"):
		slider.value = audio_settings.master_volume
		_update_value_label(slider.value)


func _on_mouse_entered_control(control_node: Control) -> void:
	@warning_ignore("unused_variable")
	var local_tooltip_text = ""
	if control_node and control_node.has_meta("tooltip_text"):
		tooltip_text = control_node.get_meta("tooltip_text")
	elif control_node and control_node.tooltip_text:
		tooltip_text = control_node.tooltip_text

	if not tooltip_text.is_empty():
		GlobalEvents.show_tooltip_requested.emit(
			{"text": tooltip_text, "position": get_global_mouse_position()}
		)


func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
