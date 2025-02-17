extends Button

@export var ParentRect : ColorRect

func _pressed():
	Steam.activateGameOverlayToWebPage("https://steamcommunity.com/sharedfiles/filedetails/?id=" + ParentRect.get("WorkshopId"))
