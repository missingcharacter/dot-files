return {
    "immanuwell/droast.nvim",
    config = function()
        require("droast").setup({
            command = "droast",
            on_save = true,
            args = { "--preset", "production" },
        })
    end,
}
