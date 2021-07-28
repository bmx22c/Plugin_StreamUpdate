#name "Stream Update"
#author "bmx22c"
#category "Streaming"

// #include "PrivateInfo.as"
#include "Formatting.as"
#include "Icons.as"

[Setting name="Client ID" password]
string Setting_ClientId;

[Setting name="Bearer" password]
string Setting_Bearer;

[Setting name="Broadcaster ID" password]
string Setting_BroadcasterId;

[Setting name="Enable live update"]
bool Setting_EnableLiveUpdate;

[Setting name="Live title" description="\{map\}"]
string Setting_LiveTitle;

string mapId = "";
// PrivateInfo::Get privateInfo;
bool streamInfoOpen = false;
string streamTitle = "";

bool inMenu = true;
bool checkedInMenu = false;

CTrackMania@ g_app;

CGameCtnChallenge@ GetCurrentMap()
{
#if MP41 || TMNEXT
	return g_app.RootMap;
#else
	return g_app.Challenge;
#endif
}

void Main()
{
	@g_app = cast<CTrackMania>(GetApp());

	Setting_LiveTitle = "";
	
	GetTwitchInfo();

	while (true) {
		CheckMap();
		yield();
	}
}

void RenderMenu()
{
	if (!UI::BeginMenu("\\$60f" + Icons::Brands::Twitch + "\\$z Stream Update")) {
		return;
	}

	if (UI::MenuItem("\\$9cf" + Icons::PencilAlt + "\\$z Update stream informations")) {
		UpdateStreamInfo();
	}
	if (UI::MenuItem("\\$9cf" + Icons::Eye + "\\$z View stream informations")) {
		ViewStreamInfo();
		streamInfoOpen = !streamInfoOpen;
	}

	UI::EndMenu();
}

void GetTwitchInfo()
{
	Net::HttpRequest req;
	req.Method = Net::HttpMethod::Get;
	req.Headers["Accept"] = "application/json";
	req.Headers["Content-Type"] = "application/json";
	req.Headers["Client-ID"] = Setting_ClientId;
	req.Headers["Authorization"] = "Bearer " + Setting_Bearer;
	req.Url = "https://api.twitch.tv/helix/channels?broadcaster_id=" + Setting_BroadcasterId;
	req.Start();
	while (!req.Finished()) {
		yield();
	}
	// TODO - Handle bad request/fails
	// print(req.String());

	auto json = Json::Parse(req.String());
	if(json["error"].GetType() == Json::Type::String){
		print('Error connecting to the API');
		return;
	}

	Setting_LiveTitle = json["data"][0]["title"];
}

void UpdateStreamInfo()
{
	if(Setting_EnableLiveUpdate){
		string title = Setting_LiveTitle;

		auto currentMap = GetCurrentMap();
		if (currentMap !is null) {
			title = Regex::Replace(title, "\\{map\\}", currentMap.MapName);
		} else {
			title = Regex::Replace(title, "\\{map\\}", "");
		}

		title = StripFormatCodes(title);

		Net::HttpRequest req;
		req.Method = Net::HttpMethod::Patch;
		req.Headers["Content-Type"] = "application/json";
		req.Headers["Client-ID"] = Setting_ClientId;
		req.Headers["Authorization"] = "Bearer " + Setting_Bearer;
		req.Url = "https://api.twitch.tv/helix/channels?broadcaster_id=" + Setting_BroadcasterId;
		req.Body = '{"title":"'+title+'"}';
		req.Start();
		while (!req.Finished()) {
			// yield();
		}

		print("Title changed: "+title);
	}
}

void CheckMap()
{
	auto currentMap = GetCurrentMap();
	if (currentMap !is null) {
		if(mapId != currentMap.EdChallengeId || inMenu == true)
		{
			mapId = currentMap.EdChallengeId;
			print("Map changed");
			UpdateStreamInfo();
		}

		inMenu = false;
		checkedInMenu = false;
	} else {
		inMenu = true;
		if(inMenu == true && checkedInMenu == false){
			checkedInMenu = true;
			UpdateStreamInfo();
		}
	}
}

void ViewStreamInfo(){
	Net::HttpRequest req;
	req.Method = Net::HttpMethod::Get;
	req.Headers["Accept"] = "application/json";
	req.Headers["Content-Type"] = "application/json";
	req.Headers["Client-ID"] = Setting_ClientId;
	req.Headers["Authorization"] = "Bearer " + Setting_Bearer;
	req.Url = "https://api.twitch.tv/helix/channels?broadcaster_id=" + Setting_BroadcasterId;
	req.Start();
	while (!req.Finished()) {
		// yield();
	}
	// TODO - Handle bad request/fails
	// print(req.String());

	auto json = Json::Parse(req.String());
	if(json["error"].GetType() == Json::Type::String){
		print('Error connecting to the API');
		return;
	}

	streamTitle = json["data"][0]["title"];
}

void RenderInterface() {
	// If streamInfoOpen then we show the popup
	// with the live title from streamTitle
	if(streamInfoOpen){
		vec2 mouse = UI::GetMousePos();
		UI::SetNextWindowPos(int(mouse.x), int(mouse.y), UI::Cond::Appearing);
		UI::Begin("\\$60f" + Icons::Brands::Twitch + "\\$z Stream Title", streamInfoOpen, UI::WindowFlags(UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoSavedSettings));
		
		UI::Text(streamTitle);
		
		UI::End();
	}
}