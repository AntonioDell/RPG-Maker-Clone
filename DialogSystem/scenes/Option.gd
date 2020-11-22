extends Button

signal clicked(slot)


var slot

# Callback Methods

func _on_Button_pressed():
	emit_signal("clicked", slot)

# Public

func set_text(new_text : String):
	self.text = new_text

