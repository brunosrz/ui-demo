extends Panel

var _tooltip_texts: Dictionary = {
	"VideoButton": "Configurações de vídeo.",
	"AudioButton": "Configurações de áudio.",
	"LanguageButton": "Configurações de idioma.",
	"InputMapButton": "Configurações de mapeamento de teclas.",
	"BackButton": "Volta para o menu anterior.",
	"ApplyButton": "Salva as configurações e volta para o menu anterior.",
}

const _ACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.15)
const _INACTIVE_MODULATE_COLOR: Color = Color(0.39, 0.39, 0.39, 0.0)

@onready
var language_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel
@onready
var input_map_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel

@onready
var _video_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton
@onready
var _audio_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton
@onready
var _input_map_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/InputMapButton
@onready
var _language_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton

@onready var _video_modulate: ColorRect = _video_button.get_node("VideoModulate")
@onready var _audio_modulate: ColorRect = _audio_button.get_node("AudioModulate")
@onready var _input_modulate: ColorRect = _input_map_button.get_node("InputModulate")
@onready var _language_modulate: ColorRect = _language_button.get_node("LanguageModulate")

var _category_modulates: Array[ColorRect]


func _ready() -> void:
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)

	_category_modulates = [_video_modulate, _audio_modulate, _input_modulate, _language_modulate]

	_video_button.mouse_entered.connect(_on_button_mouse_entered.bind(_video_button))
	_audio_button.mouse_entered.connect(_on_button_mouse_entered.bind(_audio_button))
	_language_button.mouse_entered.connect(_on_button_mouse_entered.bind(_language_button))
	_input_map_button.mouse_entered.connect(_on_button_mouse_entered.bind(_input_map_button))
	$PanelContainer/Margin/Box/BottomButtonsContainer/BackButton.mouse_entered.connect(
		_on_button_mouse_entered.bind($PanelContainer/Margin/Box/BottomButtonsContainer/BackButton)
	)
	$PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton.mouse_entered.connect(
		_on_button_mouse_entered.bind($PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton)
	)

	_video_button.mouse_exited.connect(_on_button_mouse_exited)
	_audio_button.mouse_exited.connect(_on_button_mouse_exited)
	_language_button.mouse_exited.connect(_on_button_mouse_exited)
	_input_map_button.mouse_exited.connect(_on_button_mouse_exited)
	$PanelContainer/Margin/Box/BottomButtonsContainer/BackButton.mouse_exited.connect(
		_on_button_mouse_exited
	)
	$PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton.mouse_exited.connect(
		_on_button_mouse_exited
	)

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
	if (
		$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings
		. has_method("_update_ui")
	):
		(
			$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings
			. _update_ui(settings_data.get("video", {}))
		)
	if (
		$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings
		. has_method("_update_ui")
	):
		(
			$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings
			. _update_ui(settings_data.get("audio", {}))
		)


func _on_loading_language_changed(language_data: Dictionary) -> void:
	if (
		$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings
		. has_method("_update_ui")
	):
		(
			$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings
			. _update_ui(language_data.get("language", {}))
		)


func _on_video_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false
	_update_category_buttons_modulate(_video_modulate)


func _on_audio_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false
	_update_category_buttons_modulate(_audio_modulate)


func _on_language_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = true
	_update_category_buttons_modulate(_language_modulate)


func _on_back_button_pressed() -> void:
	print(
		"[OptionsMenu] Botão 'Voltar' pressionado. Revertendo configurações e voltando ao estado anterior."
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


func _on_input_map_button_pressed() -> void:
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings.visible = false
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/InputMapSettings.visible = true
	$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel.visible = false
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/InputMapLabel.visible = true
	$PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel.visible = false
	_update_category_buttons_modulate(_input_modulate)


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state_key = state_data.get("new_state", "")
	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.SETTINGS])
