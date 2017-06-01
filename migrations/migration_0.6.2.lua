for _, force in pairs(game.forces) do
    for _, surface in pairs(game.surfaces) do
        for _, ent in pairs(surface.find_entities_filtered{force = force}) do
            ent.update_connections()
        end
    end
end
game.print("Updating all connections.")
