extends Panel

const _ACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.15)
const _INACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.0)

var _tooltip_texts: Dictionary = {
	"VideoButton": "Configurações de vídeo.",
	"AudioButton": "Configurações de áudio.",
	"LanguageButton": "Configurações de idioma.",
	"InputMapButton": "Configurações de mapeamento de teclas.",
	"BackButton": "Volta para o menu anterior.",
	"ApplyButton": "Salva as configurações e volta para o menu anterior.",
}
var _category_modulates: Array[ColorRect]

@onready var _box: Control = $PanelContainer/Margin/Box

@onready var _label_container: Control = _box.get_node("UPButtons/LabelContainer")
@onready var _video_label: Label = _label_container.get_node("VideoLabel")
@onready var _audio_label: Label = _label_container.get_node("AudioLabel")
@onready var _language_label: Label = _label_container.get_node("LanguageLabel")
@onready var _input_map_label: Label = _label_container.get_node("InputMapLabel")

@onready var _content: Control = _box.get_node("ContentHBox/ScrollContent/CategoryContent")
@onready var _video_settings_panel: Control = _content.get_node("VideoSettings")
@onready var _audio_settings_panel: Control = _content.get_node("AudioSettings")
@onready var _input_map_settings_panel: Control = _content.get_node("InputMapSettings")
@onready var _language_settings_panel: Control = _content.get_node("LanguageSettings")

@onready var _category_list: Control = _box.get_node("ContentHBox/ScrollList/CategoryList")
@onready var _video_button: Button = _category_list.get_node("VideoButton")
@onready var _audio_button: Button = _category_list.get_node("AudioButton")
@onready var _input_map_button: Button = _category_list.get_node("InputMapButton")
@onready var _language_button: Button = _category_list.get_node("LanguageButton")

@onready var _back_button: Button = _box.get_node("BottomButtonsContainer/BackButton")
@onready var _apply_button: Button = _box.get_node("BottomButtonsContainer/ApplyButton")

@onready var _video_modulate: ColorRect = _video_button.get_node("VideoModulate")
@onready var _audio_modulate: ColorRect = _audio_button.get_node("AudioModulate")
@onready var _input_modulate: ColorRect = _input_map_button.get_node("InputModulate")
@onready var _language_modulate: ColorRect = _language_button.get_node("LanguageModulate")


func _ready() -> void:
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)

	_category_modulates = [_video_modulate, _audio_modulate, _input_modulate, _language_modulate]

	_video_button.mouse_entered.connect(_on_button_mouse_entered.bind(_video_button))
	_audio_button.mouse_entered.connect(_on_button_mouse_entered.bind(_audio_button))
	_language_button.mouse_entered.connect(_on_button_mouse_entered.bind(_language_button))
	_input_map_button.mouse_entered.connect(_on_button_mouse_entered.bind(_input_map_button))
	_back_button.mouse_entered.connect(_on_button_mouse_entered.bind(_back_button))
	_apply_button.mouse_entered.connect(_on_button_mouse_entered.bind(_apply_button))

	_video_button.mouse_exited.connect(_on_button_mouse_exited)
	_audio_button.mouse_exited.connect(_on_button_mouse_exited)
	_language_button.mouse_exited.connect(_on_button_mouse_exited)
	_input_map_button.mouse_exited.connect(_on_button_mouse_exited)
	_back_button.mouse_exited.connect(_on_button_mouse_exited)
	_apply_button.mouse_exited.connect(_on_button_mouse_exited)

	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)
	GlobalEvents.loading_language_changed.connect(_on_loading_language_changed)

	GlobalEvents.request_loading_settings_changed.emit()
	GlobalEvents.request_loading_language_changed.emit()

	_update_category_buttons_modulate(_video_modulate)


func _update_category_buttons_modulate(active_modulate: ColorRect) -> void:
	for modulate_rect in _category_modulates:
		if modulate_rect == active_modulate:
			modulate_rect.color = _ACTIVE_MODULATE_COLOR
		else:
			modulate_rect.color = _INACTIVE_MODULATE_COLOR


func _on_loading_settings_changed(settings_data: Dictionary) -> void:
	if _video_settings_panel.has_method("_update_ui"):
		_video_settings_panel._update_ui(settings_data.get("video", {}))
	if _audio_settings_panel.has_method("_update_ui"):
		_audio_settings_panel._update_ui(settings_data.get("audio", {}))


func _on_loading_language_changed(language_data: Dictionary) -> void:
	if _language_settings_panel.has_method("_update_ui"):
		_language_settings_panel._update_ui(language_data.get("language", {}))


func _show_category(
	video_visible: bool, audio_visible: bool, input_map_visible: bool, language_visible: bool
) -> void:
	_video_settings_panel.visible = video_visible
	_audio_settings_panel.visible = audio_visible
	_input_map_settings_panel.visible = input_map_visible
	_language_settings_panel.visible = language_visible
	_video_label.visible = video_visible
	_audio_label.visible = audio_visible
	_input_map_label.visible = input_map_visible
	_language_label.visible = language_visible


func _on_video_button_pressed() -> void:
	_show_category(true, false, false, false)
	_update_category_buttons_modulate(_video_modulate)


func _on_audio_button_pressed() -> void:
	_show_category(false, true, false, false)
	_update_category_buttons_modulate(_audio_modulate)


func _on_language_button_pressed() -> void:
	_show_category(false, false, false, true)
	_update_category_buttons_modulate(_language_modulate)


func _on_input_map_button_pressed() -> void:
	_show_category(false, false, true, false)
	_update_category_buttons_modulate(_input_modulate)


func _on_back_button_pressed() -> void:
	print(
		(
			"[OptionsMenu] Botão 'Voltar' pressionado. "
			+ "Revertendo configurações e voltando ao estado anterior."
		)
	)

	GlobalEvents.request_loading_settings_changed.emit()
	GlobalEvents.request_loading_language_changed.emit()

	GlobalEvents.return_to_previous_state_requested.emit()


func _on_apply_button_pressed() -> void:
	print("[OptionsMenu] Botão 'Aplicar' pressionado. Solicitando salvamento de configurações.")

	GlobalEvents.request_saving_settings_changed.emit()
	GlobalEvents.request_saving_language_changed.emit()

	GlobalEvents.return_to_previous_state_requested.emit()


func _on_button_mouse_entered(button: Button) -> void:
	var button_name = button.name
	if _tooltip_texts.has(button_name):
		GlobalEvents.show_tooltip_requested.emit(
			{
				"text": _tooltip_texts[button_name],
				"position": get_global_mouse_position() + Vector2(10, 10)
			}
		)


func _on_button_mouse_exited() -> void:
	GlobalEvents.hide_tooltip_requested.emit()


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state_key = state_data.get("new_state", "")
	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.SETTINGS])
