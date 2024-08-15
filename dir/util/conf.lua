local conf = {
    scale_factor=4,
    tile_width=16,
}

function love.conf(t)
    t.console = true
end

function conf:arrayToPos(x,y)
    return x*self:Transform(),y*self:Transform()
end
function conf:posToArray(x,y)
    return x/self:Transform(),y/self:Transform()
end
function conf:multiplyTransform(x)
    return x*self:Transform()
end
function conf:Transform()
    return scale_factor*tile_width
end

return conf