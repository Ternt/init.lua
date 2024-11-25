return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local Ttph_Fugitive = vim.api.nvim_create_augroup("Ttph_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd

        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}
