require"src/button"

return {
    background = {
        -- Chaque "bloc" est une zone colorée avec position/largeur/hauteur
        { x = 1, y = 4, width = 10, height = 16, color = colors.gray },
        { x = 12, y = 1, width = 8, height = 3, color = colors.lightGray },
    },

    buttons = {
        -- Chaque bouton est une instance Button
        Button.new("AE2", 5, 8, 12, 3, colors.green, colors.white, colors.black, function()
            print("Lancer appuyé")
        end),
        Button.new("Quitter", 5, 12, 12, 3, colors.red, colors.white, colors.white, function()
            print("Quitter appuyé")
        end),
        Button.new("Main", 5, 16, 12, 3, colors.red, colors.white, colors.white, function()
            return "PIC/main_menu"
        end),
    }
}