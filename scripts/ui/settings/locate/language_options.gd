extends VBoxContainer

const _ACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.15)
const _INACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.0)


func _ready() -> void:
	_connect_language_buttons()
	GlobalEvents.loading_language_changed.connect(_on_language_data_received)
	GlobalEvents.language_changed.connect(_on_language_data_received)
	_update_language_buttons_modulate()


func _connect_language_buttons() -> void:
	for button in get_children():
		if button is Button:
			var locale_code = button.get_meta("locale", "")
			if not locale_code.is_empty():
				button.pressed.connect(_on_language_button_pressed.bind(locale_code))


func _on_language_button_pressed(locale_code: String) -> void:
	var change_data = {"language": {"locale": locale_code}}
	GlobalEvents.language_changed.emit(change_data)


func _on_language_data_received(language_data: Dictionary) -> void:
	if not language_data.has("language") or not language_data.language.has("locale"):
		return
	_update_language_buttons_modulate()


func _update_language_buttons_modulate() -> void:
	var current_locale = TranslationServer.get_locale()
	for button in get_children():
		if button is Button:
			var color_rect: ColorRect = button.get_node_or_null("ColorRect")
			var button_locale = button.get_meta("locale", "")
			if color_rect and not button_locale.is_empty():
				if button_locale == current_locale:
					color_rect.color = _ACTIVE_MODULATE_COLOR
				else:
					color_rect.color = _INACTIVE_MODULATE_COLOR
