extends HBoxContainer

@onready var option_button: OptionButton = $WindowModeOptionButton
@onready var window_mode_label: Label = $WindowModeLabel


func _ready() -> void:
	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	window_mode_label.mouse_entered.connect(_on_mouse_entered_control.bind(window_mode_label))
	window_mode_label.mouse_exited.connect(_on_mouse_exited_control)
	option_button.mouse_entered.connect(_on_mouse_entered_control.bind(option_button))
	option_button.mouse_exited.connect(_on_mouse_exited_control)


func _on_window_mode_option_button_item_selected(index: int) -> void:
	var _mode: int

	match index:
		0:
			_mode = 0
		1:
			_mode = 2
		2:
			_mode = 3
		_:
			push_warning("Modo de janela desconhecido selecionado: " + str(index))
			return

	GlobalEvents.emit_signal("setting_changed", {"video": {"window_mode": _mode}})


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("window_mode"):
		var window_mode = settings.video.window_mode
		for i in range(option_button.item_count):
			if option_button.get_item_id(i) == window_mode:
				option_button.select(i)
				break


func _on_mouse_entered_control(control_node: Control) -> void:
	@warning_ignore("shadowed_variable_base_class")
	var tooltip_text: String = ""
	if control_node.has_meta("tooltip_text"):
		tooltip_text = control_node.get_meta("tooltip_text")
	elif control_node.tooltip_text:
		tooltip_text = tr(control_node.tooltip_text)

	if not tooltip_text.is_empty():
		GlobalEvents.show_tooltip_requested.emit(
			{"text": tooltip_text, "position": get_global_mouse_position()}
		)


func _on_mouse_exited_control() -> void:
	GlobalEvents.hide_tooltip_requested.emit()
