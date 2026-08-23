extends PanelContainer


func set_text(text_content: String):
	$RichTextLabel.text = text_content
	visible = true


func _ready():
	visible = false
