for _,force in pairs(game.forces) do
    force.recipes["sticky-note"].enabled = force.technologies["sticky-notes"].researched
    force.recipes["sticky-sign"].enabled = force.technologies["sticky-notes"].researched
end
