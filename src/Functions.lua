--< Functions >--
local function Function(numberOfParameters, fn)
    return {
        NumberOfParameters = numberOfParameters;
        Fn = fn;
    }
end

--< Module >--
return {
    abs = Function(1, math.abs);
    acos = Function(1, math.acos);
    asin = Function(1, math.asin);
    atan = Function(1, math.atan);
    atan2 = Function(2, math.atan2);
    ceil = Function(1, math.ceil);
    clamp = Function(3, math.clamp);
    cos = Function(1, math.cos);
    cosh = Function(1, math.cosh);
    deg = Function(1, math.deg);
    exp = Function(1, math.exp);
    floor = Function(1, math.floor);
    fmod = Function(2, math.fmod);
    ldexp = Function(2, math.ldexp);
    log = Function(2, math.log);
    max = Function(nil, math.max);
    min = Function(nil, math.min);
    noise = Function(3, math.noise);
    pow = Function(2, math.pow);
    rad = Function(1, math.rad);
    random = Function(2, math.random);
    sign = Function(1, math.sign);
    sin = Function(1, math.sin);
    sinh = Function(1, math.sinh);
    sqrt = Function(1, math.sqrt);
    tan = Function(1, math.tan);
    tanh = Function(1, math.tanh);
}