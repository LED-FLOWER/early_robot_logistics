
-- Early Robot Logistics
-- Unlock all target recipes from the beginning
-- and replace their ingredients with cheaper recipes.

local chest_recipes = {
  "active-provider-chest",
  "passive-provider-chest",
  "storage-chest",
  "buffer-chest",
  "requester-chest"
}

local robot_recipes = {
  "construction-robot",
  "logistic-robot"
}

local function make_recipe_free_to_unlock(recipe_name, ingredients)
  local recipe = data.raw.recipe[recipe_name]

  if not recipe then
    log(
      "[Early Robot Logistics] Recipe not found: "
      .. recipe_name
    )
    return
  end

  -- Set the ingredients.
  recipe.ingredients = ingredients

  -- Enable the recipe at the start of the game.
  recipe.enabled = true

  -- Remove technology unlock requirements from all technologies.
  for _, technology in pairs(data.raw.technology or {}) do
    if technology.effects then
      for i = #technology.effects, 1, -1 do
        local effect = technology.effects[i]

        if effect.type == "unlock-recipe"
          and effect.recipe == recipe_name
        then
          table.remove(technology.effects, i)
        end
      end
    end
  end

  log(
    "[Early Robot Logistics] Unlocked from start: "
    .. recipe_name
  )
end

-- Logistic chests: 2 iron plates each.
for _, recipe_name in ipairs(chest_recipes) do
  make_recipe_free_to_unlock(recipe_name, {
    { type = "item", name = "iron-plate", amount = 2 }
  })
end

-- Construction and logistic robots.
for _, recipe_name in ipairs(robot_recipes) do
  make_recipe_free_to_unlock(recipe_name, {
    { type = "item", name = "electronic-circuit", amount = 1 },
    { type = "item", name = "iron-gear-wheel", amount = 1 },
    { type = "item", name = "iron-plate", amount = 1 }
  })
end

-- Roboport: 10 iron plates, 10 iron gears, 5 copper cables.
make_recipe_free_to_unlock("roboport", {
  { type = "item", name = "iron-plate", amount = 10 },
  { type = "item", name = "iron-gear-wheel", amount = 10 },
  { type = "item", name = "copper-cable", amount = 5 }
})

log("[Early Robot Logistics] All recipe changes completed.")
