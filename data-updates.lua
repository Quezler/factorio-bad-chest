-- Count the number of resources we will scan
local resources = {item = {}, fluid = {}}
local add_scanner_resource = function(entity)
  if entity.minable then
    if entity.minable.result then
      resources["item"][entity.minable.result] = 1
    end
    if entity.minable.results then
      for _, result in pairs(entity.minable.results) do
        if result.name then
          local type = result.type or "item"
          resources[type][result.name] = 1
        end
      end
    end
  end
end

-- Uncharted chunks
resources["item"]["signal-black"] = 1

-- Water
resources["fluid"]["water"] = 1

-- Cliff explosives
if data.raw["capsule"]["cliff-explosives"] then
  resources["item"]["cliff-explosives"] = 1
end

-- Artillery shell
if data.raw["ammo"]["artillery-shell"] then
  resources["item"]["artillery-shell"] = 1
end

-- Resources
for _, resource in pairs(data.raw["resource"]) do
  add_scanner_resource(resource)
end

-- Trees
for _, tree in pairs(data.raw["tree"]) do
  add_scanner_resource(tree)
end

-- Rocks
for _, entity in pairs(data.raw["simple-entity"]) do
  if entity.count_as_rock_for_filtered_deconstruction then
    add_scanner_resource(entity)
  end
end

-- Fish
for _, fish in pairs(data.raw["fish"]) do
  add_scanner_resource(fish)
end

-- Set resource scanner output size
data.raw["constant-combinator"]["recursive-blueprints-scanner"].item_slot_count = table_size(resources["item"]) + table_size(resources["fluid"])
