extends Control

enum TABS { MAIN, OPTIONS, SAVE_LOAD }

export (String, "en", "nl") var options_language = "en" setget set_options_language

onready var tabs := $CenterContainer/MetalPanel/MarginContainer/TabContainer
onready var main_menu := tabs.find_node("MainMenu", false)
onready var options := tabs.find_node("Options", false)
onready var save_load := tabs.find_node("SaveLoad", false)

onready var languages := options.find_node("Languages")


func _ready():
	_change_tab(TABS.MAIN)
	set_options_language(options_language)


func set_options_language(language: String):
	options_language = language
	TranslationServer.set_locale(language)
	if name:
		match language:
			"en":
				languages.selected = 0
			"nl":
				languages.selected = 1


func _on_Start_pressed():
	assert(OK == get_tree().change_scene("res://scenes/tesseract-fps/HyperWorld.tscn"))


func _on_Options_pressed():
	_change_tab(TABS.OPTIONS)


func _on_SaveLoad_pressed():
	_change_tab(TABS.SAVE_LOAD)


func _on_Back_pressed():
	_change_tab(TABS.MAIN)


func _on_Exit_pressed():
	get_tree().quit()


func _change_tab(index: int):
	match index:
		TABS.MAIN:
			main_menu.find_node("Start").grab_focus()
		TABS.OPTIONS:
			options.find_node("Back").grab_focus()
		TABS.SAVE_LOAD:
			save_load.find_node("Back").grab_focus()
		_:
			assert(false)
	tabs.current_tab = index


func _on_Languages_item_selected(index: int):
	match languages.get_item_text(index):
		"English":
			set_options_language("en")
		"Nederlands":
			set_options_language("nl")
