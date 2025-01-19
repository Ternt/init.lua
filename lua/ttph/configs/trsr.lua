local options = {
    -- A list of parser names, or "all"
    ensure_installed = {
        "lua", "rust", "jsdoc", "bash", "c", "markdown",
        "javascript", "typescript", "html", "css", "yaml",
        "json", "toml", "tsx"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
    auto_install = true,

    indent = {
        enable = true
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },
}

return options
