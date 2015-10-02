local util = {}

-- Returns the key for a value, in a table
function util.getkeyfromvalue(tabl, val)
  for key,value in pairs(tabl) do
    if val==value then
      return key
    end
  end
  return nil
end

return util
