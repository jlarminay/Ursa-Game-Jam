extends Node

# References to the actual TextBox UI in the scene
var text_box_ui: Control = null
var text_label: Label = null
var is_text_showing: bool = false
var player: CharacterBody2D
var current_lines: Array[String] = []
var current_line_index: int = 0
var waiting_for_input: bool = false

# Signal for text completion
signal text_finished

func _ready() -> void:
  pass

func show_text(lines: Array[String]) -> Signal:
  if not text_box_ui:
    find_textbox_in_scene()

  if not text_box_ui or not text_label:
    text_finished.emit()
    return text_finished

  is_text_showing = true
  Game.can_player_move = false

  # Store lines and start with first one
  current_lines = lines
  current_line_index = 0
  waiting_for_input = false

  text_box_ui.visible = true

  # Show first line and start the sequence
  show_next_line()

  return text_finished

func show_next_line() -> void:
  if current_line_index < current_lines.size():
    # Show current line with newline support
    var line_text = current_lines[current_line_index]
    text_label.text = line_text.replace("\\n", "\n")
    waiting_for_input = true
  else:
    # All lines shown, end the dialogue
    hide_text()

func find_textbox_in_scene() -> void:
  # Single search for TextBox anywhere in the scene
  text_box_ui = get_tree().current_scene.find_child("TextBox", true, false)
  if text_box_ui:
    text_label = text_box_ui.find_child("Dialogue", true, false)

    # Hide by default and set to highest layer
    text_box_ui.visible = false
    text_box_ui.z_index = 1000 # Highest layer
  else:
    pass

func hide_text() -> void:
  if text_box_ui:
    text_box_ui.visible = false

  is_text_showing = false
  text_finished.emit()

func _input(event: InputEvent) -> void:
    if is_text_showing and waiting_for_input and event.is_action_pressed("ui_accept"):
        # Move to next line
        current_line_index += 1
        waiting_for_input = false
        show_next_line()
