extends PanelContainer

@onready var content_container: VBoxContainer = $VBoxContainer


func setup_popover(content_data: Dictionary) -> void:
	for child in content_container.get_children():
		child.queue_free()

	if content_data.has("title"):
		var title_label = Label.new()
		title_label.text = content_data["title"]
		content_container.add_child(title_label)

	if content_data.has("message"):
		var message_label = Label.new()
		message_label.text = content_data["message"]
		content_container.add_child(message_label)

	if content_data.has("button_text"):
		var button = Button.new()
		button.text = content_data["button_text"]
		button.pressed.connect(
			func():
				GlobalEvents.emit_signal(
					"popover_button_pressed", content_data.get("button_action", "")
				)
				hide_popover()
		)
		content_container.add_child(button)

	visible = true


func hide_popover() -> void:
	visible = false
