-- A map script will run the execute function (below) on the current map
-- Map scripts can be selected and run from the "Tools->Run Script" menu in the map editor

function execute(map)
    local editor = App.mapEditor()
    local selectedLines = editor:selectedLines()

    if #selectedLines == 0 then
        App.logMessage('Select Connected Line Textures: No Lines Selected')
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
                local vertices = { entry.vertex1, entry.vertex2 }
                for j = 1, #vertices do
                    local vertex = vertices[j]
                    local connectedLines = vertex:connectedLines()
                    for k = 1, #connectedLines do
                        local line = connectedLines[k]
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

    App.logMessage('Select Connected Line Textures: Success')
end
