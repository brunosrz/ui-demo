extends HBoxContainer

@onready var checkbox: CheckBox = $ReduceScreenShakeCheckBox
@onready var reduce_screen_shake_label: Label = $ReduceScreenShakeLabel


func _ready() -> void:
	checkbox.toggled.connect(_on_reduce_screen_shake_check_box_toggled)

	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)

	reduce_screen_shake_label.mouse_entered.connect(
		_on_mouse_entered_control.bind(reduce_screen_shake_label)
	)
	reduce_screen_shake_label.mouse_exited.connect(_on_mouse_exited_control)
	checkbox.mouse_entered.connect(_on_mouse_entered_control.bind(checkbox))
	checkbox.mouse_exited.connect(_on_mouse_exited_control)


func _on_reduce_screen_shake_check_box_toggled(button_pressed: bool) -> void:
	GlobalEvents.emit_signal("setting_changed", {"video": {"reduce_screen_shake": button_pressed}})


func _on_loading_settings_changed(settings: Dictionary) -> void:
	if settings.has("video") and settings.video.has("reduce_screen_shake"):
		checkbox.button_pressed = settings.video.reduce_screen_shake


func _on_mouse_entered_control(control_node: Control) -> void:
	var tooltip_text: String = ""
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
