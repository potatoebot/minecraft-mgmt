worlds["potatoebot"] = "/home/ubuntu/world"

renders["day"] = {
    "world": "potatoebot",
    "title": "day",
    "rendermode": smooth_lighting,
    "dimension": "overworld",
}

renders["nite"] = {
    "world": "potatoebot",
    "title": "nite",
    "rendermode": smooth_night,
    "dimension": "overworld",
}

renders["nether"] = {
    "world": "potatoebot",
    "title": "nether",
    "rendermode": nether_smooth_lighting,
    "dimension": "nether",
}

renders["flip"] = {
    "world": "potatoebot",
    "title": "flip",
    "rendermode": smooth_lighting,
    "dimension": "overworld",
    "northdirection" : "lower-right",
}

outputdir = "/home/ubuntu/outworld"