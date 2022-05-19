all: ut

.PHONY: ut
ut:
	godot-server -d -s --path . addons/gut/gut_cmdln.gd -gprefix='Test' -gdir=res://tests/ut -gexit 2>/dev/null
