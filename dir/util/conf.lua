local conf = {
    scale_factor=4,
    tile_width=16,
    transform=16*4,
}

function love.conf(t)
    t.console = true
end

function conf:arrayToPos(x,y)
    return x*transform,y*transform
end
function conf:posToArray(x,y)
    return x/transform,y/transform
end
function conf:multiplyTransform(x)
    return x*transform
end

return conf