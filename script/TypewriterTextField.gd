tool extends RichTextLabel

func _set(k, v):
	if "bbcode_text" == k:
		(custom_effects[0] as TypewriterEffect).reset()
