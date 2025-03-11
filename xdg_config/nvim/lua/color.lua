local M = {}

--- @param h number      The hue
--- @param s number      The saturation
--- @param l number      The lightness
--- @return number, number, number     # The RGB representation
function M.hsl_to_rgb(h, s, l)
  --- @type number, number, number
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    --- @param p number
    --- @param q number
    --- @param t number
    local function hue_to_rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    --- @type number
    local q
    if l < 0.5 then
      q = l * (1 + s)
    else
      q = l + s - l * s
    end
    local p = 2 * l - q

    r = hue_to_rgb(p, q, h + 1 / 3)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1 / 3)
  end

  return r * 255, g * 255, b * 255
end

--- @param  r number?   The red
--- @param  g number?   The green
--- @param  b number?   The blue
--- @return   string   # The hex representation
function M.rgb_to_hex(r, g, b)
  return string.format('#%02x%02x%02x', r, g, b)
end

--- @param  h number?   The hue
--- @param  s number?   The saturation
--- @param  l number?   The lightness
--- @return   string   # The hex representation
function M.hsl_to_hex(h, s, l)
  local r, g, b = M.hsl_to_rgb(h / 360, s / 100, l / 100)

  return string.format('#%02x%02x%02x', r, g, b)
end


return M
