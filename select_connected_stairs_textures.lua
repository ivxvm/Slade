-- A map script will run the execute function (below) on the current map
-- Map scripts can be selected and run from the "Tools->Run Script" menu in the map editor

function execute(map)
    local editor = App.mapEditor()
    local selectedLines = editor:selectedLines()

    if #selectedLines == 0 then
        App.logMessage('Select Connected Stairs Textures: No Lines Selected')
        return
    end

    local seen = {}
    local queue = {}

    local targetTextureBottom = selectedLines[1].side1.textureBottom
    local targetTextureMiddle = selectedLines[1].side1.textureMiddle
    local targetTextureTop = selectedLines[1].side1.textureTop

    for i = 1, #selectedLines do
        local line = selectedLines[i]
        table.insert(queue, line)
        seen[line.index] = true
    end

    while true do
        local isQueueEmpty = true
        for i, entry in ipairs(queue) do
            if entry then
                -- line -> sides -> sectors -> lines
                local sides = { entry.side1, entry.side2 }
                for j = 1, #sides do
                    local sector = sides[j].sector
                    local connectedSides = sector.connectedSides
                    for k = 1, #connectedSides do
                        local line = connectedSides[k].line
                        if not seen[line.index] then
                            local bottomMatch = line.side1.textureBottom == targetTextureBottom
                            local middleMatch = line.side1.textureMiddle == targetTextureMiddle
                            local topMatch = line.side1.textureTop == targetTextureTop
                            if bottomMatch and middleMatch and topMatch then
                                editor:select(line)
                                table.insert(queue, line)
                            end
                            seen[line.index] = true
                        end
                    end
                end
                isQueueEmpty = false
                queue[i] = nil
            end
        end
        if isQueueEmpty then
            break
        end
    end

    App.logMessage('Select Connected Stairs Textures: Success')
end
