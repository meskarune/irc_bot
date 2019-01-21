local sql = require 'lsqlite3'

db = nil -- global database handle

local database = {}

database.init = function (ms)
    db = sql.open(ms.config.dbpath)
    if not db then print('Failed to open the database') end

    -- run the dbinit() function that any module exposes
    for m in pairs(ms) do
        if type(ms[m]) == 'table' and type(ms[m].dbinit) == 'function' then
            ms[m].dbinit()
        end
    end
end

database.cleanup = function (ms)
    -- run the dbcleanup() function that any module exposes
    for m in pairs(ms) do
        if type(ms[m]) == 'table' and type(ms[m].dbcleanup) == 'function' then
            ms[m].dbcleanup()
        end
    end

    db:close()
end

return database