extends Control

@onready
var video_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/VideoButton
@onready
var audio_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/AudioButton
@onready
var language_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollList/CategoryList/LanguageButton
@onready var back_button: Button = $PanelContainer/Margin/Box/BottomButtonsContainer/BackButton

@onready
var video_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings
@onready
var audio_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings
@onready
var language_settings_panel: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings
@onready var apply_button: Button = $PanelContainer/Margin/Box/BottomButtonsContainer/ApplyButton

@onready var video_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/VideoLabel
@onready var audio_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/AudioLabel
@onready
var language_label: Label = $PanelContainer/Margin/Box/UPButtons/LabelContainer/LanguageLabel

@onready
var master_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/MasterSlider
@onready
var music_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/MusicSlider
@onready
var sfx_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/AudioSettings/SfxSlider
@onready
var language_options_container: VBoxContainer = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/LanguageSettings/LanguageOptionsContainer

@onready
var monitor_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Monitor/MonitorOptionButton
@onready
var window_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Window/WindowModeOptionButton
@onready
var resolution_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Resolution/ResolutionOptionButton
@onready
var field_of_view_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Field/FieldOfViewSlider
@onready
var aspect_ratio_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Aspect/AspectRatioOptionButton
@onready
var dynamic_render_scale_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/DynamicRender/DynamicRenderScaleOptionButton
@onready
var render_scale_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/RenderScale/RenderScaleSlider
@onready
var frame_rate_limit_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/FrameRate/FrameRateLimitOptionButton
@onready
var max_frame_rate_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/MaxFrame/MaxFrameRateSlider
@onready
var vsync_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/VSync/VSyncOptionButton
@onready
var triple_buffering_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/TripleBuffering/TripleBufferingCheckBox
@onready
var reduce_buffering_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/ReduceBuffering/ReduceBufferingCheckBox
@onready
var low_latency_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/LowLatency/LowLatencyModeOptionButton
@onready
var gamma_correction_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/GammaCorrection/GammaCorrectionSlider
@onready
var contrast_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Contrast/ContrastSlider
@onready
var brightness_slider: HSlider = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Brightness/BrightnessSlider
@onready
var hdr_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/HDR/HDROptionButton
@onready
var hdr_calibration_button: Button = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/HDRCalibrationButton
@onready
var shaders_quality_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Shaders/ShadersQualityOptionButton
@onready
var effects_quality_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/EffectsQuality/EffectsQualityOptionButton
@onready
var colorblind_mode_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/Colorblind/ColorblindModeOptionButton
@onready
var reduce_screen_shake_check_box: CheckBox = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/ReduceScreenShake/ReduceScreenShakeCheckBox
@onready
var ui_scale_option_button: OptionButton = $PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent/VideoSettings/UIScale/UIScaleOptionButton

const _locales = {"pt_br": "Português", "en": "English", "es": "Español", "fr": "Français"}

const _window_modes = {
	DisplayServer.WINDOW_MODE_WINDOWED: "UI_WINDOW_MODE_WINDOWED",
	DisplayServer.WINDOW_MODE_FULLSCREEN: "UI_WINDOW_MODE_FULLSCREEN",
}

const _aspect_ratios = {
	0: "16:9",
	1: "4:3",
	2: "21:9",
}

const _dynamic_render_scale_modes = {
	0: "UI_DRS_OFF",
	1: "UI_DRS_CUSTOM",
}

const _frame_rate_limits = {
	0: "UI_FPS_CUSTOM",
	1: "30",
	2: "60",
	3: "144",
	4: "240",
	5: "360",
}

const _vsync_modes = {
	DisplayServer.VSYNC_DISABLED: "UI_VSYNC_OFF",
	DisplayServer.VSYNC_ENABLED: "UI_VSYNC_ON",
	DisplayServer.VSYNC_ADAPTIVE: "UI_VSYNC_ADAPTIVE",
}

const _low_latency_modes = {
	0: "UI_LOW_LATENCY_OFF",
	1: "UI_LOW_LATENCY_ENABLED",
	2: "UI_LOW_LATENCY_ENABLED_BOOST",
}

const _hdr_modes = {
	0: "UI_HDR_OFF",
	1: "UI_HDR_ON",
}

const _quality_levels = {
	0: "UI_QUALITY_LOW",
	1: "UI_QUALITY_MEDIUM",
	2: "UI_QUALITY_HIGH",
}

const _colorblind_modes = {
	0: "UI_COLORBLIND_OFF",
	1: "UI_COLORBLIND_PROTANOPIA",
	2: "UI_COLORBLIND_DEUTERANOPIA",
	3: "UI_COLORBLIND_TRITANOPIA",
}

const _ui_scale_presets = {
	"small": "UI_SCALE_SMALL",
	"medium": "UI_SCALE_MEDIUM",
	"large": "UI_SCALE_LARGE",
}


func _ready() -> void:
	video_button.pressed.connect(func(): _show_panel(video_settings_panel, video_label))
	audio_button.pressed.connect(func(): _show_panel(audio_settings_panel, audio_label))
	language_button.pressed.connect(func(): _show_panel(language_settings_panel, language_label))

	_populate_language_buttons()
	_populate_video_buttons()

	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	monitor_option_button.item_selected.connect(_on_monitor_selected)
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)
	resolution_option_button.item_selected.connect(_on_resolution_selected)

	field_of_view_slider.value_changed.connect(_on_field_of_view_changed)
	aspect_ratio_option_button.item_selected.connect(_on_aspect_ratio_selected)
	dynamic_render_scale_option_button.item_selected.connect(_on_dynamic_render_scale_selected)
	render_scale_slider.value_changed.connect(_on_render_scale_changed)
	frame_rate_limit_option_button.item_selected.connect(_on_frame_rate_limit_selected)
	max_frame_rate_slider.value_changed.connect(_on_max_frame_rate_changed)
	vsync_option_button.item_selected.connect(_on_vsync_mode_selected)
	triple_buffering_check_box.toggled.connect(_on_triple_buffering_toggled)
	reduce_buffering_check_box.toggled.connect(_on_reduce_buffering_toggled)
	low_latency_mode_option_button.item_selected.connect(_on_low_latency_mode_selected)
	gamma_correction_slider.value_changed.connect(_on_gamma_correction_changed)
	contrast_slider.value_changed.connect(_on_contrast_changed)
	brightness_slider.value_changed.connect(_on_brightness_changed)
	hdr_option_button.item_selected.connect(_on_hdr_mode_selected)
	hdr_calibration_button.pressed.connect(_on_hdr_calibration_button_pressed)
	shaders_quality_option_button.item_selected.connect(_on_shaders_quality_selected)
	effects_quality_option_button.item_selected.connect(_on_effects_quality_selected)
	colorblind_mode_option_button.item_selected.connect(_on_colorblind_mode_selected)
	reduce_screen_shake_check_box.toggled.connect(_on_reduce_screen_shake_toggled)
	ui_scale_option_button.item_selected.connect(_on_ui_scale_selected)

	apply_button.pressed.connect(_on_apply_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	GlobalEvents.loading_settings_changed.connect(_on_loading_settings_changed)
	GlobalEvents.setting_changed.connect(_on_setting_changed_from_manager)
	GlobalEvents.language_changed.connect(_on_language_changed_from_manager)
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)

	for button in [
		video_button,
		audio_button,
		language_button,
		apply_button,
		back_button,
		hdr_calibration_button
	]:
		button.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for slider in [
		master_slider,
		music_slider,
		sfx_slider,
		field_of_view_slider,
		render_scale_slider,
		max_frame_rate_slider,
		gamma_correction_slider,
		contrast_slider,
		brightness_slider
	]:
		slider.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for option_btn in [
		monitor_option_button,
		window_mode_option_button,
		resolution_option_button,
		aspect_ratio_option_button,
		dynamic_render_scale_option_button,
		frame_rate_limit_option_button,
		vsync_option_button,
		low_latency_mode_option_button,
		hdr_option_button,
		shaders_quality_option_button,
		effects_quality_option_button,
		colorblind_mode_option_button,
		ui_scale_option_button
	]:
		option_btn.mouse_entered.connect(_on_mouse_entered_interactive_element)
	for check_box in [
		triple_buffering_check_box, reduce_buffering_check_box, reduce_screen_shake_check_box
	]:
		check_box.mouse_entered.connect(_on_mouse_entered_interactive_element)

	if SettingsManager and SettingsManager.settings:
		_on_settings_loaded(SettingsManager.settings)

	_show_panel(video_settings_panel, video_label)


func _exit_tree():
	GlobalEvents.settings_loaded.disconnect(_on_settings_loaded)
	GlobalEvents.game_state_changed.disconnect(_on_game_state_changed)


func _populate_language_buttons():
	for locale_code in _locales:
		var button = Button.new()
		button.text = _locales[locale_code]
		button.name = locale_code
		button.pressed.connect(_on_language_button_pressed.bind(locale_code))
		button.mouse_entered.connect(_on_mouse_entered_interactive_element)
		language_options_container.add_child(button)


func _populate_video_buttons():
	monitor_option_button.clear()
	var display_options = SettingsManager.get_display_options()
	for i in range(display_options.monitors.size()):
		monitor_option_button.add_item("Monitor " + str(i + 1), i)

	window_mode_option_button.clear()
	for mode_enum in _window_modes:
		window_mode_option_button.add_item(_window_modes[mode_enum], mode_enum)

	_update_resolution_options(0)

	aspect_ratio_option_button.clear()
	for ratio_enum in _aspect_ratios:
		aspect_ratio_option_button.add_item(_aspect_ratios[ratio_enum], ratio_enum)

	dynamic_render_scale_option_button.clear()
	for mode_enum in _dynamic_render_scale_modes:
		dynamic_render_scale_option_button.add_item(
			_dynamic_render_scale_modes[mode_enum], mode_enum
		)

	frame_rate_limit_option_button.clear()
	for limit_enum in _frame_rate_limits:
		frame_rate_limit_option_button.add_item(_frame_rate_limits[limit_enum], limit_enum)

	vsync_option_button.clear()
	for mode_enum in _vsync_modes:
		vsync_option_button.add_item(_vsync_modes[mode_enum], mode_enum)

	low_latency_mode_option_button.clear()
	for mode_enum in _low_latency_modes:
		low_latency_mode_option_button.add_item(_low_latency_modes[mode_enum], mode_enum)

	hdr_option_button.clear()
	for mode_enum in _hdr_modes:
		hdr_option_button.add_item(_hdr_modes[mode_enum], mode_enum)

	shaders_quality_option_button.clear()
	for level_enum in _quality_levels:
		shaders_quality_option_button.add_item(_quality_levels[level_enum], level_enum)

	effects_quality_option_button.clear()
	for level_enum in _quality_levels:
		effects_quality_option_button.add_item(_quality_levels[level_enum], level_enum)

	colorblind_mode_option_button.clear()
	for mode_enum in _colorblind_modes:
		colorblind_mode_option_button.add_item(_colorblind_modes[mode_enum], mode_enum)

	ui_scale_option_button.clear()
	for preset_key in _ui_scale_presets:
		ui_scale_option_button.add_item(
			_ui_scale_presets[preset_key], ui_scale_option_button.get_item_count()
		)
		ui_scale_option_button.set_item_metadata(
			ui_scale_option_button.get_item_count() - 1, preset_key
		)


func _update_resolution_options(monitor_index: int):
	resolution_option_button.clear()
	var display_options = SettingsManager.get_display_options()
	if monitor_index < display_options.monitors.size():
		var resolutions = display_options.monitors[monitor_index].resolutions
		for res_vec in resolutions:
			var res_text = "%dx%d" % [res_vec.x, res_vec.y]
			resolution_option_button.add_item(res_text)
			resolution_option_button.set_item_metadata(
				resolution_option_button.get_item_count() - 1, res_vec
			)


func _show_panel(panel_to_show: VBoxContainer, label_to_show: Label) -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")

	for child in (
		$PanelContainer/Margin/Box/ContentHBox/ScrollContent/CategoryContent.get_children()
	):
		if child is VBoxContainer:
			child.visible = (child == panel_to_show)

	for label_child in $PanelContainer/Margin/Box/UPButtons/LabelContainer.get_children():
		if label_child is Label:
			label_child.visible = (label_child == label_to_show)


func _on_master_volume_changed(value: float):
	GlobalEvents.setting_changed.emit({"audio": {"master_volume": value}})


func _on_music_volume_changed(value: float):
	GlobalEvents.setting_changed.emit({"audio": {"music_volume": value}})


func _on_sfx_volume_changed(value: float):
	GlobalEvents.setting_changed.emit({"audio": {"sfx_volume": value}})


func _on_monitor_selected(index: int):
	var monitor_id = monitor_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"monitor_index": monitor_id})
	_update_resolution_options(monitor_id)


func _on_window_mode_selected(index: int):
	var mode_id = window_mode_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"window_mode": mode_id})

	resolution_option_button.disabled = (mode_id != DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_resolution_selected(index: int):
	var resolution_vec = resolution_option_button.get_item_metadata(index)
	GlobalEvents.setting_changed.emit(
		{"resolution": {"x": resolution_vec.x, "y": resolution_vec.y}}
	)


func _on_field_of_view_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"field_of_view": value})


func _on_aspect_ratio_selected(index: int) -> void:
	var ratio_id = aspect_ratio_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"aspect_ratio": ratio_id})


func _on_dynamic_render_scale_selected(index: int) -> void:
	var mode_id = dynamic_render_scale_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"dynamic_render_scale_mode": mode_id})
	render_scale_slider.visible = (mode_id == 1)
	render_scale_slider.get_parent().get_node("RenderScaleLabel").visible = (mode_id == 1)


func _on_render_scale_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"render_scale": value})


func _on_frame_rate_limit_selected(index: int) -> void:
	var mode_id = frame_rate_limit_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"frame_rate_limit_mode": mode_id})
	max_frame_rate_slider.visible = (mode_id == 0)
	max_frame_rate_slider.get_parent().get_node("MaxFrameRateLabel").visible = (mode_id == 0)


func _on_max_frame_rate_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"max_frame_rate": int(value)})


func _on_vsync_mode_selected(index: int) -> void:
	var mode_id = vsync_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"vsync_mode": mode_id})


func _on_triple_buffering_toggled(button_pressed: bool) -> void:
	GlobalEvents.setting_changed.emit({"triple_buffering": button_pressed})


func _on_reduce_buffering_toggled(button_pressed: bool) -> void:
	GlobalEvents.setting_changed.emit({"reduce_buffering": button_pressed})


func _on_low_latency_mode_selected(index: int) -> void:
	var mode_id = low_latency_mode_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"low_latency_mode": mode_id})


func _on_gamma_correction_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"gamma_correction": value})


func _on_contrast_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"contrast": value})


func _on_brightness_changed(value: float) -> void:
	GlobalEvents.setting_changed.emit({"brightness": value})


func _on_hdr_mode_selected(index: int) -> void:
	var mode_id = hdr_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"hdr_mode": mode_id})


func _on_hdr_calibration_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	print("HDR Calibration button pressed (placeholder).")


func _on_shaders_quality_selected(index: int) -> void:
	var quality_id = shaders_quality_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"shaders_quality": quality_id})


func _on_effects_quality_selected(index: int) -> void:
	var quality_id = effects_quality_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"effects_quality": quality_id})


func _on_colorblind_mode_selected(index: int) -> void:
	var mode_id = colorblind_mode_option_button.get_item_id(index)
	GlobalEvents.setting_changed.emit({"colorblind_mode": mode_id})


func _on_reduce_screen_shake_toggled(button_pressed: bool) -> void:
	GlobalEvents.setting_changed.emit({"reduce_screen_shake": button_pressed})


func _on_ui_scale_selected(index: int) -> void:
	var preset_key = ui_scale_option_button.get_item_metadata(index)
	GlobalEvents.setting_changed.emit({"ui_scale_preset": preset_key})


func _on_language_button_pressed(locale_code: String):
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.language_changed.emit({"language": {"locale": locale_code}})
	_update_language_buttons(locale_code)


func _on_apply_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.request_saving_settings_changed.emit()
	print("Solicitação para salvar configurações enviada.")


func _on_back_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.request_loading_settings_changed.emit()
	GlobalEvents.return_to_previous_state_requested.emit()


func _on_mouse_entered_interactive_element():
	SoundSys.play_sfx_requested.emit("ui_rollover", "SFX")


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state_key = state_data.get("new_state", "")

	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.SETTINGS])


func _on_loading_settings_changed(settings_data: Dictionary) -> void:
	master_slider.value = settings_data.get("master_volume", 1.0)
	music_slider.value = settings_data.get("music_volume", 1.0)
	sfx_slider.value = settings_data.get("sfx_volume", 1.0)

	var current_locale = settings_data.get("locale", "pt_br")
	_update_language_buttons(current_locale)

	var monitor_index = settings_data.get("monitor_index", 0)
	if monitor_option_button.get_item_index(monitor_index) != -1:
		monitor_option_button.select(monitor_option_button.get_item_index(monitor_index))

	var window_mode = settings_data.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	if window_mode_option_button.get_item_index(window_mode) != -1:
		window_mode_option_button.select(window_mode_option_button.get_item_index(window_mode))
	resolution_option_button.disabled = (window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN)

	_update_resolution_options(monitor_index)
	var res_dict = settings_data.get("resolution", {"x": 1920, "y": 1080})
	var current_res = Vector2i(res_dict.x, res_dict.y)
	for i in range(resolution_option_button.get_item_count()):
		if resolution_option_button.get_item_metadata(i) == current_res:
			resolution_option_button.select(i)
			break

	field_of_view_slider.value = settings_data.get("field_of_view", field_of_view_slider.min_value)

	var aspect_ratio_mode = settings_data.get("aspect_ratio", 0)
	if aspect_ratio_option_button.get_item_index(aspect_ratio_mode) != -1:
		aspect_ratio_option_button.select(
			aspect_ratio_option_button.get_item_index(aspect_ratio_mode)
		)

	var dynamic_render_scale_mode = settings_data.get("dynamic_render_scale_mode", 0)
	if dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode) != -1:
		dynamic_render_scale_option_button.select(
			dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode)
		)
	render_scale_slider.visible = (dynamic_render_scale_mode == 1)
	render_scale_slider.get_parent().get_node("RenderScaleLabel").visible = (
		dynamic_render_scale_mode == 1
	)
	render_scale_slider.value = settings_data.get("render_scale", 1.0)

	var frame_rate_limit_mode = settings_data.get("frame_rate_limit_mode", 0)
	if frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode) != -1:
		frame_rate_limit_option_button.select(
			frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode)
		)
	max_frame_rate_slider.visible = (frame_rate_limit_mode == 0)
	max_frame_rate_slider.get_parent().get_node("MaxFrameRateLabel").visible = (
		frame_rate_limit_mode == 0
	)
	max_frame_rate_slider.value = settings_data.get("max_frame_rate", 60)

	var vsync_mode = settings_data.get("vsync_mode", DisplayServer.VSYNC_ENABLED)
	if vsync_option_button.get_item_index(vsync_mode) != -1:
		vsync_option_button.select(vsync_option_button.get_item_index(vsync_mode))

	triple_buffering_check_box.button_pressed = settings_data.get("triple_buffering", false)
	reduce_buffering_check_box.button_pressed = settings_data.get("reduce_buffering", false)

	var low_latency_mode = settings_data.get("low_latency_mode", 0)
	if low_latency_mode_option_button.get_item_index(low_latency_mode) != -1:
		low_latency_mode_option_button.select(
			low_latency_mode_option_button.get_item_index(low_latency_mode)
		)

	gamma_correction_slider.value = settings_data.get("gamma_correction", 2.2)
	contrast_slider.value = settings_data.get("contrast", 1.0)
	brightness_slider.value = settings_data.get("brightness", 1.0)

	var hdr_mode = settings_data.get("hdr_mode", 0)
	if hdr_option_button.get_item_index(hdr_mode) != -1:
		hdr_option_button.select(hdr_option_button.get_item_index(hdr_mode))

	var shaders_quality = settings_data.get("shaders_quality", 2)
	if shaders_quality_option_button.get_item_index(shaders_quality) != -1:
		shaders_quality_option_button.select(
			shaders_quality_option_button.get_item_index(shaders_quality)
		)

	var effects_quality = settings_data.get("effects_quality", 2)
	if effects_quality_option_button.get_item_index(effects_quality) != -1:
		effects_quality_option_button.select(
			effects_quality_option_button.get_item_index(effects_quality)
		)

	var colorblind_mode = settings_data.get("colorblind_mode", 0)
	if colorblind_mode_option_button.get_item_index(colorblind_mode) != -1:
		colorblind_mode_option_button.select(
			colorblind_mode_option_button.get_item_index(colorblind_mode)
		)

	reduce_screen_shake_check_box.button_pressed = settings_data.get("reduce_screen_shake", false)

	var ui_scale_preset = settings_data.get("ui_scale_preset", "medium")
	for i in range(ui_scale_option_button.get_item_count()):
		if ui_scale_option_button.get_item_metadata(i) == ui_scale_preset:
			ui_scale_option_button.select(i)
			break

	print("ui de Configurações atualizada com os dados carregados.")


func _on_setting_changed_from_manager(change_data: Dictionary) -> void:
	_update_ui_from_settings_data(change_data)


func _on_language_changed_from_manager(change_data: Dictionary) -> void:
	var current_locale = change_data.get("language", {}).get("locale", "pt_br")
	_update_language_buttons(current_locale)


func _update_ui_from_settings_data(settings_data: Dictionary) -> void:
	if settings_data.has("audio"):
		var audio_settings = settings_data["audio"]
		if audio_settings.has("master_volume"):
			master_slider.value = audio_settings["master_volume"]
		if audio_settings.has("music_volume"):
			music_slider.value = audio_settings["music_volume"]
		if audio_settings.has("sfx_volume"):
			sfx_slider.value = audio_settings["sfx_volume"]

	if settings_data.has("monitor_index"):
		var monitor_index = settings_data["monitor_index"]
		if monitor_option_button.get_item_index(monitor_index) != -1:
			monitor_option_button.select(monitor_option_button.get_item_index(monitor_index))

	if settings_data.has("window_mode"):
		var window_mode = settings_data["window_mode"]
		if window_mode_option_button.get_item_index(window_mode) != -1:
			window_mode_option_button.select(window_mode_option_button.get_item_index(window_mode))
		resolution_option_button.disabled = (window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN)

	if settings_data.has("resolution"):
		var res_dict = settings_data["resolution"]
		var current_res = Vector2i(res_dict.x, res_dict.y)
		for i in range(resolution_option_button.get_item_count()):
			if resolution_option_button.get_item_metadata(i) == current_res:
				resolution_option_button.select(i)
				break

	if settings_data.has("field_of_view"):
		field_of_view_slider.value = settings_data["field_of_view"]

	if settings_data.has("aspect_ratio"):
		var aspect_ratio_mode = settings_data["aspect_ratio"]
		if aspect_ratio_option_button.get_item_index(aspect_ratio_mode) != -1:
			aspect_ratio_option_button.select(
				aspect_ratio_option_button.get_item_index(aspect_ratio_mode)
			)

	if settings_data.has("dynamic_render_scale_mode"):
		var dynamic_render_scale_mode = settings_data["dynamic_render_scale_mode"]
		if dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode) != -1:
			dynamic_render_scale_option_button.select(
				dynamic_render_scale_option_button.get_item_index(dynamic_render_scale_mode)
			)
		render_scale_slider.visible = (dynamic_render_scale_mode == 1)
		render_scale_slider.get_parent().get_node("RenderScaleLabel").visible = (
			dynamic_render_scale_mode == 1
		)

	if settings_data.has("render_scale"):
		render_scale_slider.value = settings_data["render_scale"]

	if settings_data.has("frame_rate_limit_mode"):
		var frame_rate_limit_mode = settings_data["frame_rate_limit_mode"]
		if frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode) != -1:
			frame_rate_limit_option_button.select(
				frame_rate_limit_option_button.get_item_index(frame_rate_limit_mode)
			)
		max_frame_rate_slider.visible = (frame_rate_limit_mode == 0)
		max_frame_rate_slider.get_parent().get_node("MaxFrameRateLabel").visible = (
			frame_rate_limit_mode == 0
		)

	if settings_data.has("max_frame_rate"):
		max_frame_rate_slider.value = settings_data["max_frame_rate"]

	if settings_data.has("vsync_mode"):
		var vsync_mode = settings_data["vsync_mode"]
		if vsync_option_button.get_item_index(vsync_mode) != -1:
			vsync_option_button.select(vsync_option_button.get_item_index(vsync_mode))

	if settings_data.has("triple_buffering"):
		triple_buffering_check_box.button_pressed = settings_data["triple_buffering"]
	if settings_data.has("reduce_buffering"):
		reduce_buffering_check_box.button_pressed = settings_data["reduce_buffering"]

	if settings_data.has("low_latency_mode"):
		var low_latency_mode = settings_data["low_latency_mode"]
		if low_latency_mode_option_button.get_item_index(low_latency_mode) != -1:
			low_latency_mode_option_button.select(
				low_latency_mode_option_button.get_item_index(low_latency_mode)
			)

	if settings_data.has("gamma_correction"):
		gamma_correction_slider.value = settings_data["gamma_correction"]
	if settings_data.has("contrast"):
		contrast_slider.value = settings_data["contrast"]
	if settings_data.has("brightness"):
		brightness_slider.value = settings_data["brightness"]

	if settings_data.has("hdr_mode"):
		var hdr_mode = settings_data["hdr_mode"]
		if hdr_option_button.get_item_index(hdr_mode) != -1:
			hdr_option_button.select(hdr_option_button.get_item_index(hdr_mode))

	if settings_data.has("shaders_quality"):
		var shaders_quality = settings_data["shaders_quality"]
		if shaders_quality_option_button.get_item_index(shaders_quality) != -1:
			shaders_quality_option_button.select(
				shaders_quality_option_button.get_item_index(shaders_quality)
			)

	if settings_data.has("effects_quality"):
		var effects_quality = settings_data["effects_quality"]
		if effects_quality_option_button.get_item_index(effects_quality) != -1:
			effects_quality_option_button.select(
				effects_quality_option_button.get_item_index(effects_quality)
			)

	if settings_data.has("colorblind_mode"):
		var colorblind_mode = settings_data["colorblind_mode"]
		if colorblind_mode_option_button.get_item_index(colorblind_mode) != -1:
			colorblind_mode_option_button.select(
				colorblind_mode_option_button.get_item_index(colorblind_mode)
			)

	if settings_data.has("reduce_screen_shake"):
		reduce_screen_shake_check_box.button_pressed = settings_data["reduce_screen_shake"]

	if settings_data.has("ui_scale_preset"):
		var ui_scale_preset = settings_data["ui_scale_preset"]
		for i in range(ui_scale_option_button.get_item_count()):
			if ui_scale_option_button.get_item_metadata(i) == ui_scale_preset:
				ui_scale_option_button.select(i)
				break

	print("ui de Configurações atualizada com os dados carregados.")


func _update_language_buttons(current_locale: String) -> void:
	for button in language_options_container.get_children():
		if button is Button:
			button.disabled = (button.name == current_locale)
