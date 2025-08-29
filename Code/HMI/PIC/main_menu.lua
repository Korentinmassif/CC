require"src/button"

return {
    background = {
        -- Chaque "bloc" est une zone colorée avec position/largeur/hauteur
        { x = 1, y = 1, width = 10, height = 5, color = colors.gray },
        { x = 12, y = 1, width = 8, height = 3, color = colors.lightGray },
    },

    buttons = {
        -- Chaque bouton est une instance Button
        Button.new("Lancer", 5, 8, 12, 3, colors.green, colors.white, colors.black, function()
            print("Lancer appuyé")
        end),
        Button.new("Quitter", 5, 12, 12, 3, colors.red, colors.white, colors.white, function()
            print("Quitter appuyé")
        end),
    }
}