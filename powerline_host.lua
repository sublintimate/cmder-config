-- * Segment object with these properties:
---- * isNeeded: sepcifies whether a segment should be added or not. For example: no Git segment is needed in a non-git folder
---- * text
---- * textColor: Use one of the color constants. Ex: colorWhite
---- * fillColor: Use one of the color constants. Ex: colorBlue
local segment = {
    isNeeded = false,
    text = "",
    textColor = colorWhite,
    fillColor = colorMagenta
}

---
-- Sets the properties of the Segment object, and prepares for a segment to be added
---
local function init()
    local prefix = segment.isNeeded and newLineSymbol or ""
    local user = os.getenv("USERNAME")
    local host = os.getenv("COMPUTERNAME")

    segment.text = prefix.." "..user.."@"..host.." "
    segment.isNeeded = true
end

---
-- Uses the segment properties to add a new segment to the prompt
---
local function addAddonSegment()
    init()
    addSegment(segment.text, segment.textColor, segment.fillColor)
end

-- Register this addon with Clink
clink.prompt.register_filter(addAddonSegment, 52)
