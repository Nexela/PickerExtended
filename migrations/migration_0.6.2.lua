for _, surface in pairs(game.surfaces) do
    for _, ent in pairs(surface.find_entities()) do
        if ent.force then
            ent.update_connections()
        end
    end
end
game.print("Updating all connections.")
