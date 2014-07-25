_G.term.bg=colors.black
_G.term.fg=colors.white
oSB=term.setBackgroundColor
oST=term.setTextColor
_G.term.setBackgroundColor = function(color)
  if term.isColor(color) then
    _G.term.bg=color
  end
  return oSB(color)
end
_G.term.getBackgroundColor = function()
  return _G.term.bg
end
_G.term.setTextColor = function(color)
  if term.isColor(color) then
    _G.term.fg=color
  end
  return oST(color)
end
_G.term.getTextColor = function()
  return _G.term.fg
end
