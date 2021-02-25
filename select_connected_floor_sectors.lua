-- A map script will run the execute function (below) on the current map
-- Map scripts can be selected and run from the "Tools->Run Script" menu in the map editor

function execute(map)
    local editor = App.mapEditor()
    local selectedSectors = editor:selectedSectors()

    if #selectedSectors == 0 then
        App.logMessage('Select Connected Floor Sectors: No Sectors Selected')
        return
    end

    local seen = {}
    local queue = {}
    local targetTexture = selectedSectors[1].textureFloor

    for i = 1, #selectedSectors do
        local sector = selectedSectors[i]
        table.insert(queue, sector)
        seen[sector.index] = true
    end

    while true do
        local isQueueEmpty = true
        for i, entry in ipairs(queue) do
            if entry then
                local connectedSides = entry.connectedSides
                for j = 1, #connectedSides do
                    local line = connectedSides[j].line
                    local sideSectors = { line.side1.sector, line.side2.sector }
                    for _, sector in ipairs(sideSectors) do
                        if not seen[sector.index] then
                            if sector.textureFloor == targetTexture then
                                editor:select(sector)
                                table.insert(queue, sector)
                            end
                            seen[sector.index] = true
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

    App.logMessage('Select Connected Floor Sectors: Success')
end
