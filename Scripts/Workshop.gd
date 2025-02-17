extends Node

func checkSteam() -> bool:
	if !Steam.isSteamRunning():
		print_debug("Steam is not running")
		return false
	if !Steam.isSubscribed():
		print_debug("Not subscribed / Ownership is not confirmed")
		return false
	return true

static func GetDir() -> String:
	if !Steam.isSteamRunning():
		print_debug("Steam is not running")
		return ""
	if !Steam.isSubscribed():
		print_debug("Not subscribed / Ownership is not confirmed")
		return ""
	var directory  = Steam.getAppInstallDir(3243190)
	var finalDir : String = directory.get("directory") + "\\..\\..\\workshop\\content\\3243190"
	if finalDir != null:
		return finalDir
	else:
		return ""
