# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import httpclient, strformat, json, sequtils

const
    baseUrl = "https://www.thebluealliance.com/api/v3/"

type
    TBA = object
        authKey: string

proc simpleStr(simple: bool): string =
    result = if simple: "/simple" else: ""

method get(tba: TBA, url: string): JsonNode {.base.} =
    let client = newHttpClient()
    client.headers = newHttpHeaders({
        "X-TBA-Auth-Key": tba.authKey
    })
    result = parseJson(client.getContent(baseUrl & url))

method teamKey(tba: TBA, id: string): string {.base.} =
    result = id

method teamKey(tba: TBA, id: int): string {.base.} =
    result = "frc" & $id

method status(tba: TBA): JsonNode {.base.} =
    result = tba.get("status")

method teams(tba: TBA, page = -1, year = -1, simple = false,
        keys = false): JsonNode {.base.} =
    if page != -1:
        if year != -1:
            if keys:
                result = tba.get(&"teams/{year}/{page}/keys")
            else:
                result = tba.get(&"teams/{year}/{page}{simpleStr(simple)}")
        else:
            if keys:
                result = tba.get(&"teams/{page}/keys")
            else:
                result = tba.get(&"teams/{page}{simpleStr(simple)}")
    else:
        var teams = tba.teams(page = 0, year = year, simple = simple, keys = keys)
        var target = 0
        while true:
            let page_teams = tba.teams(page = target, year = year,
                    simple = simple, keys = keys)
            if page_teams.len() == 0:
                break
            else:
                teams.elems = concat(teams.elems, page_teams.elems)
            target += 1

        result = teams

method team(tba: TBA, team: string, simple = false): JsonNode {.base.} =
    var simpleStr = if simple: "/simple" else: ""
    return tba.get(&"team/{team}{simpleStr}")

method teamEvents(tba: TBA, team: string, year = -1, simple = false,
        keys = false): JsonNode {.base.} =
    if year != -1:
        if keys:
            result = tba.get(&"team/{team}/events/{year}/keys")
        else:
            result = tba.get(&"team/{team}/events/{year}{simpleStr(simple)}")
    else:
        if keys:
            result = tba.get(&"team/{team}/events/keys")
        else:
            result = tba.get(&"team/{team}/events{simpleStr(simple)}")

method teamAwards(tba: TBA, team: string, year = -1, event = ""): JsonNode {.base.} =
    if event.len() != 0:
        result = tba.get(&"team/{team}/event/{event}/awards")
    else:
        if year != -1:
            result = tba.get(&"team/{team}/awards/{year}")
        else:
            result = tba.get(&"team/{team}/awards")

method teamMatches(tba: TBA, team: string, event = "", year = -1,
        simple = false, keys = false): JsonNode {.base.} =
    if event.len() != 0:
        if keys:
            result = tba.get(&"team/{team}/event/{event}/matches/keys")
        else:
            result = tba.get(&"team/{team}/event/{event}/matches{simpleStr(simple)}")
    elif year != -1:
        if keys:
            result = tba.get(&"team/{team}/matches/{year}/keys")
        else:
            result = tba.get(&"team/{team}/matches/{year}{simpleStr(simple)}")

method teamYears(tba: TBA, team: string): JsonNode {.base.} =
    result = tba.get(&"team/{team}/years_participated")

method teamMedia(tba: TBA, team: string, year = -1, tag = ""): JsonNode {.base.} =
    var tagStr = if tag.len() != 0: &"/tag/{tag}" else: ""
    var yearStr = if year != -1: &"/{year}" else: ""
    result = tba.get(&"team/{team}/media{tagStr}{yearStr}")

method teamRobots(tba: TBA, team: string): JsonNode {.base.} =
    result = tba.get(&"team/{team}/robots")

method teamDistricts(tba: TBA, team: string): JsonNode {.base.} =
    result = tba.get(&"team/{team}/districts")

method teamProfiles(tba: TBA, team: string): JsonNode {.base.} =
    result = tba.get(&"team/{team}/social_media")

method teamStatus(tba: TBA, team: string, event: string): JsonNode {.base.} =
    result = tba.get(&"team/{team}/event/{event}/status")

method events(tba: TBA, year: int, simple = false, keys = false): JsonNode {.base.} =
    if keys:
        result = tba.get(&"events/{year}/keys")
    else:
        result = tba.get(&"events/{year}{simpleStr(simple)}")

method event(tba: TBA, event: string, simple = false): JsonNode {.base.} =
    result = tba.get(&"event/{event}{simpleStr(simple)}")

method eventAlliances(tba: TBA, event: string): JsonNode {.base.} =
    result = tba.get(&"event/{event}/alliances")

method eventDistrictPoints(tba: TBA, event: string): JsonNode {.base.} =
    result = tba.get(&"event/{event}/district_points")


when isMainModule:
    echo "Enter auth key:"
    var tba = TBA(authKey: readLine(stdin))
    echo pretty(tba.eventDistrictPoints("2019nytr"))

