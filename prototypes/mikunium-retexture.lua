require("commons")

-- Gets new textures by replacing the base root folder with the mod root folder
local function getNewTexturePath(oldPath)
    local newPath = string.gsub(oldPath, "^__base__", modRoot)
    return newPath
end

-- Takes an array of items {typeName, internalName} and replaces textures and pictures w/ mod files
local function replacePrototypeTexture(prototypeType, internalName)
    local prototype = data.raw[prototypeType][internalName]
    if prototype then
        prototype.icon = getNewTexturePath(prototype.icon)

        -- Replace item varations for belts/ground
        if prototype.pictures and prototype.pictures.layers then
            for _, layer in ipairs(prototype.pictures.layers) do
                layer.filename = getNewTexturePath(layer.filename)
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
    mikuOreItem.icon = getNewTexturePath(mikuOreItem.icon)
    mikuOreItem.icon_size = 64

    -- Replace ore variations for belts/ground
    local pics = mikuOreItem.pictures
    if pics then
        for _, pic in ipairs(pics) do
            if pic.layers then
                for _, layer in ipairs(pic.layers) do
                    layer.filename = getNewTexturePath(layer.filename)
                end
            else
                pic.filename = getNewTexturePath(pic.filename)
            end
        end
    end
end

-- Replace resource and map colors

local oreResource = data.raw["resource"]["uranium-ore"]
if oreResource then
    oreResource.icon = getNewTexturePath(oreResource.icon)
    oreResource.map_color = mikuColor
    oreResource.mining_visualisation_tint = mikuColor
    local oreResourceSheet = oreResource.stages.sheet
    oreResourceSheet.filename = getNewTexturePath(oreResourceSheet.filename)
    if oreResource.stages_effect then
        local oreResourceEffectSheet = oreResource.stages_effect.sheet
        oreResourceEffectSheet.filename = getNewTexturePath(oreResourceEffectSheet.filename)
    end
end

-- Replace centrifuge glow

local centrifugeEntity = data.raw["assembling-machine"]["centrifuge"]
if centrifugeEntity then
    local lights = centrifugeEntity["graphics_set"]["working_visualisations"][2].animation.layers
    for _, light in ipairs(lights) do
        light.filename = getNewTexturePath(light.filename)
    end
end

-- Change the color of the rocket tip for nukes when shot from the rocket launcher

local atomicRocketProjectile = data.raw["projectile"]["atomic-rocket"]
if atomicRocketProjectile then
    atomicRocketProjectile.animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation(
        mikuColor)
end

local nukeExplosion = data.raw["explosion"]["nuke-explosion"]
if nukeExplosion then
    local stripes = nukeExplosion["animations"]["stripes"]
    if stripes then
        for _, stripe in ipairs(stripes) do
            stripe.filename = getNewTexturePath(stripe.filename)
        end
    end
end

local nukeShockwave = data.raw["explosion"]["atomic-nuke-shockwave"]
if nukeShockwave then
    local animations = nukeShockwave["animations"]
    if animations then
        for _, anim in ipairs(animations) do
            anim.filename = getNewTexturePath(anim.filename)
        end
    end
end
