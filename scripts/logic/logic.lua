-- ITEM COUNT CHECKS
function badges_count()
    return Tracker:ProviderCountForCode('badge')
end

function key_items_count()
    count = 0
    -- accounting for the purchasable evo stones
    if celadon() and not has('opt_stonesanity_on') then
        count = 4
    end
    return count  + Tracker:ProviderCountForCode('keyitem')
end

function pokedex_count()
    return Tracker:FindObjectForCode('pokemon').AcquiredCount
end

function fossil_count()
    local fossils = Tracker:ProviderCountForCode("fossil")
    return fossils
end

-- HM CHECKS
function cut()
    return has('cut') and has('cascade')
end

function fly()
    return has('fly') and has('thunder')
end

function surf()
    return has('surf') and has('soul')
end

function strength()
    return has('strength') and has('rainbow')
end

function flash()
    return has('flash') and has('boulder')
end

function flyto(location)
    return fly() and has("fly_"..location)
end

-- ITEM ACCESS CHECKS
function cardkey(floor)
    return has('cardkey') or has('cardkey'..floor..'f') or has('cardkey_progressive', floor-1)
end

function hidden()
    return has('opt_itemfinder_off') or has('itemfinder')
end

function aide(route)
    code = 'opt_aide_' .. route
    print(code)
    required = Tracker:FindObjectForCode(code).AcquiredCount
    caught = pokedex_count()
    return required <= caught and (has('pokedex') or has('opt_dex_required_off'))

end

-- ROADBLOCK CHECKS
function old_man()
    return has('opt_old_man_on') or has('parcel')
end

function extra_boulders()
    return strength() or has('opt_extra_boulders_off')
end

function cyclingroad()
    return has('bicycle') or has('opt_bike_skips_on')
end

function rock_tunnel()
    return flash() or has('opt_dark_rock_tunnel_on')
end

-- LOCATION ACCESS CHECKS
function pewter()
    return old_man() or cut() or (cerulean() and surf())
end

function rt3()
    return has('opt_rt3open') or (has('opt_rt3boulder') and has('boulder')) or (has('opt_rt3badge') and has ('badge'))
end

function cerulean()
    flight =  flyto('cerulean')
    underground = flyto('vermilion')
    gate = saffron() and has('tea')
    rt3_passable = rt3() and old_man()
    rocktunnel = cut() and lavender() --this skips checking for flash, which we'll do in accessrules i think?
    return flight or underground or rt3_passable or rocktunnel
end

function lavender()
    flight = flyto('lavender')
    gate = saffron() and has('tea')
    underground = flyto('celadon')
    rock_tunnel = cerulean() and cut()

    flute = has('pokeflute')
    boulders = extra_boulders()
    via_vermilion = cerulean() and flute and boulders
    via_fuchsia = fuchsia() and surf() or (flute and boulders)
    return flight or underground or gate or rock_tunnel
end

function celadon()
    return lavender()
end

function vermilion()
    return cerulean()
end

function saffron()
    return flyto('saffron') or ((has('tea') or (celadon() and has('opt_tea_off'))) and (lavender() or cerulean()))
end

function fuchsia()
    flight = flyto('fuchsia')
    via_cinnabar = surf() and strength()
    flute = has('pokeflute')
    cycling_road = cyclingroad() and cerulean() and flute
    boulders = extra_boulders()
    via_vermilion = cerulean() and has('pokeflute') and boulders
    via_lavender = lavender() and (surf() or (flute and boulders))
    return flight or via_cinnabar or cycling_road or via_vermilion or via_lavender
end

function cinnabar()
    return surf() or flyto('cinnabar')
end

function indigo()
    return flyto('indigo') or (rt23() and victoryroad() and surf() and strength())
end



function elite4()
    local obj = Tracker:FindObjectForCode("e4b_digit")
    local badges_required = obj.CurrentStage
    -- local badges = badges()
    local hundreds = 0
    local tens = 0
    local ones = 0

    obj = Tracker:FindObjectForCode("e4k_digit1")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4k_digit2")
    if obj then
        ones = obj.CurrentStage
    end
    local key_items_required = (10 * tens) + ones
    -- local key_items = key_items()
    obj = Tracker:FindObjectForCode("e4p_digit1")
    if obj then
        hundreds = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4p_digit2")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4p_digit3")
    if obj then
        ones = obj.CurrentStage
    end
    local pokedex_required = (100 * hundreds) + (10 * tens) + ones
    local pokedex = pokedex_count()


    return ((badges_count() >= badges_required) and (key_items() >= key_items_required) and (pokedex >= pokedex_required))
end

function victoryroad()
    local obj = Tracker:FindObjectForCode("vr_digit")
    if obj then
        local count = obj.CurrentStage
        return (badges_count() >= count)
    end
    return false
end

function rt23()
    local obj = Tracker:FindObjectForCode("rt22_digit")
    local req = obj.CurrentStage
    return badges_count() >= req
end

function viridiangym()
    local obj = Tracker:FindObjectForCode("vg_digit")
    -- local badges = badges()
    if obj then
        local count = obj.CurrentStage
        return (badges_count() >= count)
    end
    return false
end

function ceruleancave()
    local obj = Tracker:FindObjectForCode("ccaveB_digit")
    -- local badges = badges()
    local badge_req = 0
    local tens = 0
    local ones = 0
    if obj then
        badge_req = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("ccaveK_digit1")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("ccaveK_digit2")
    if obj then
        ones = obj.CurrentStage
    end
    local key_item_req = (10 * tens) + ones
    -- print(key_items() .. "items out of " .. key_item_count)
    -- print(badges().."out of "..badge_count)
    return (key_items() >= key_item_req) and (badges_count() >= badge_req)
end