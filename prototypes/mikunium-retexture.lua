require("commons")

-- Gets new file paths by replacing the base root folder with the mod root folder
local function getNewModPath(oldPath)
    local newPath = string.gsub(oldPath, "^__base__", modRoot)
    return newPath
end

-- Takes an array of items {typeName, internalName} and replaces textures and pictures w/ mod files
local function replacePrototypeTexture(prototypeType, internalName)
    local prototype = data.raw[prototypeType][internalName]
    if prototype then
        prototype.icon = getNewModPath(prototype.icon)

        -- Replace item varations for belts/ground
        if prototype.pictures and prototype.pictures.layers then
            for _, layer in ipairs(prototype.pictures.layers) do
                layer.filename = getNewModPath(layer.filename)
            end
        end
    end
end

-- Actually do it
for _, replacementPair in ipairs(replacementPairs) do
    replacePrototypeTexture(replacementPair[1], replacementPair[2])
end

-- Replace the ore textures
-- Tried to combine with above but either the ore or items would break

local mikuOreItem = data.raw["item"]["uranium-ore"]
if mikuOreItem then
    mikuOreItem.icon = getNewModPath(mikuOreItem.icon)
    mikuOreItem.icon_size = 64

    -- Replace ore variations for belts/ground
    local pics = mikuOreItem.pictures
    if pics then
        for _, pic in ipairs(pics) do
            if pic.layers then
                for _, layer in ipairs(pic.layers) do
                    layer.filename = getNewModPath(layer.filename)
                end
            else
                pic.filename = getNewModPath(pic.filename)
            end
        end
    end
end

-- Replace resource and map colors

local oreResource = data.raw["resource"]["uranium-ore"]
if oreResource then
    oreResource.icon = getNewModPath(oreResource.icon)
    oreResource.map_color = mikuColor
    oreResource.mining_visualisation_tint = mikuColor
    local oreResourceSheet = oreResource.stages.sheet
    oreResourceSheet.filename = getNewModPath(oreResourceSheet.filename)
    if oreResource.stages_effect then
        local oreResourceEffectSheet = oreResource.stages_effect.sheet
        oreResourceEffectSheet.filename = getNewModPath(oreResourceEffectSheet.filename)
    end
end

-- Replace centrifuge glow

local centrifugeEntity = data.raw["assembling-machine"]["centrifuge"]
if centrifugeEntity then
    local lights = centrifugeEntity["graphics_set"]["working_visualisations"][2].animation.layers
    for _, light in ipairs(lights) do
        light.filename = getNewModPath(light.filename)
    end
    -- Was gonna change this too but I think hearing "popipo" on staggered loop 40 times at once would drive me insane
    -- Maybe I'll add it later as an option
    -- local workingSound = centrifugeEntity.working_sound
    -- if workingSound.sound then
    --     for _, varation in ipairs(workingSound.sound) do
    --         varation.filename = getNewModPath(varation.filename)
    --     end
    -- end
end

-- Change the color of the rocket tip for nukes when shot from the rocket launcher

local atomicRocketProjectile = data.raw["projectile"]["atomic-rocket"]
if atomicRocketProjectile then
    atomicRocketProjectile.animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation(
        mikuColor)
end

-- Change color of nuke explosion

local nukeExplosion = data.raw["explosion"]["nuke-explosion"]
if nukeExplosion then
    local stripes = nukeExplosion["animations"]["stripes"]
    if stripes then
        for _, stripe in ipairs(stripes) do
            stripe.filename = getNewModPath(stripe.filename)
        end
    end
end

-- Change color of nuke shockwave

local nukeShockwave = data.raw["explosion"]["atomic-nuke-shockwave"]
if nukeShockwave then
    local animations = nukeShockwave["animations"]
    if animations then
        for _, anim in ipairs(animations) do
            anim.filename = getNewModPath(anim.filename)
        end
    end
end
