local COLLISION_CLASSES = {
  -- NOTE: Ordering matters!

  -- Player
  PlayerBody = {},
  PlayerFeet = {},

  -- Players Arm
  ArmOut = {},
  ArmIn = {},

  -- Tiles
}

return function(world)

  for collClass,collConfig in pairs(COLLISION_CLASSES) do
    world:addCollisionClass(collClass, collConfig or {})
  end

end
