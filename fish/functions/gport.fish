function gport
    lsof -n -i :$argv
end
