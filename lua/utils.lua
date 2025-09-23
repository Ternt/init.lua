local M = {}

M.getenvs = function(env)
    if not env or env == "" then
        error('string expected', 2)
    end

    return os.getenv(env)
end

return M
