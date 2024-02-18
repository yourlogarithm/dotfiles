function dotenv
    export (cat $argv |xargs -L 1)
end
