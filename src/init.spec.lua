return function()
    local Evaluate = require(script.Parent)

    it("should add 1 to 1", function()
        expect(Evaluate("1 + 1")).to.equal(1 + 1)
    end)

    it("should subtract 1 from 1", function()
        expect(Evaluate("1 - 1")).to.equal(1 - 1)
    end)

    it("should multiply 2 by 2", function()
        expect(Evaluate("2 * 2")).to.equal(2 * 2)
    end)

    it("should divide 8 by 2", function()
        expect(Evaluate("8 / 2")).to.equal(8 / 2)
    end)

    it("should take 8 to the power of 2", function()
        expect(Evaluate("8 ^ 2")).to.equal(8 ^ 2)
    end)

    it("should take 8 modulo 2", function()
        expect(Evaluate("8 % 2")).to.equal(8 % 2)
    end)

    it("should solve abs", function()
        expect(Evaluate("abs(0-4)")).to.equal(math.abs(-4))
    end)

    it("should solve acos", function()
        expect(Evaluate("acos(0)")).to.equal(math.acos(0))
    end)

    it("should solve asin", function()
        expect(Evaluate("asin(1)")).to.equal(math.asin(1))
    end)

    it("should solve atan", function()
        expect(Evaluate("atan(4)")).to.equal(math.atan(4))
    end)

    it("should solve ceil", function()
        expect(Evaluate("ceil(2.2)")).to.equal(math.ceil(2.2))
    end)

    it("should solve cos", function()
        expect(Evaluate("cos(4)")).to.equal(math.cos(4))
    end)

    it("should solve cosh", function()
        expect(Evaluate("cosh(4)")).to.equal(math.cosh(4))
    end)

    it("should solve deg", function()
        expect(Evaluate("deg(1.3)")).to.equal(math.deg(1.3))
    end)

    it("should solve exp", function()
        expect(Evaluate("exp(1.3)")).to.equal(math.exp(1.3))
    end)

    it("should solve floor", function()
        expect(Evaluate("floor(1.3)")).to.equal(math.floor(1.3))
    end)

    it("should solve rad", function()
        expect(Evaluate("rad(90)")).to.equal(math.rad(90))
    end)

    it("should solve sign", function()
        expect(Evaluate("sign(4)")).to.equal(math.sign(4))
    end)

    it("should solve sin", function()
        expect(Evaluate("sin(4)")).to.equal(math.sin(4))
    end)

    it("should solve sinh", function()
        expect(Evaluate("sinh(4)")).to.equal(math.sinh(4))
    end)

    it("should solve sqrt", function()
        expect(Evaluate("sqrt(4)")).to.equal(math.sqrt(4))
    end)

    it("should solve tan", function()
        expect(Evaluate("tan(4)")).to.equal(math.tan(4))
    end)

    it("should solve tanh", function()
        expect(Evaluate("tanh(4)")).to.equal(math.tanh(4))
    end)

    it("should solve pow", function()
        expect(Evaluate("pow(4, 2)")).to.equal(math.pow(4, 2))
    end)

    it("should solve pow", function()
        expect(Evaluate("pow(4, 2^5 + 2)")).to.equal(math.pow(4, 2^5 + 2))
    end)

    it("should solve min", function()
        expect(Evaluate("min(2, 4, 5, 3)")).to.equal(math.min(2, 4, 5, 3))
    end)

    it("should solve max", function()
        expect(Evaluate("min(2, 5)")).to.equal(math.pow(2, 5))
    end)

    it("should solve clamp", function()
        expect(Evaluate("clamp(10, 1, 5)")).to.equal(math.clamp(10, 1, 5))
    end)

    it("should solve correctly x1", function()
        expect(Evaluate("5 + ((1 + 2) * 4) - 3")).to.equal(5 + ((1 + 2) * 4) - 3)
    end)

    it("should solve correctly x2", function()
        expect(Evaluate("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3)
    end)

    it("should solve correctly x3", function()
        expect(Evaluate("10 + 4 ^ 3 * 2 % 4 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(10 + 4 ^ 3 * 2 % 4 / ( 1 - 5 ) ^ 2 ^ 3)
    end)

    it("should solve correctly x4", function()
        expect(Evaluate("4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3")).to.equal(4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3)
    end)

    it("should solve correctly x5", function()
        expect(Evaluate("sqrt(4) + 3")).to.equal(math.sqrt(4) + 3)
    end)

    it("should solve correctly x6", function()
        expect(Evaluate("1+sqrt(4)")).to.equal(1+math.sqrt(4))
    end)

    it("should solve correctly x7", function()
        expect(Evaluate("sin(0.5) + sqrt(4 + 5 * 3)")).to.equal(math.sin(0.5) + math.sqrt(4 + 5 * 3))
    end)

    it("should solve correctly x8", function()
        expect(Evaluate("sin(0.5) + $var", {var = 2.35})).to.equal(math.sin(0.5) + 2.35)
    end)

    it("should solve correctly x9", function()
        expect(Evaluate("$varOne*$varTwo", {varOne = 3, varTwo = 5})).to.equal(3*5)
    end)

    it("should solve correctly x10", function()
        expect(Evaluate("(3 * ($Level+2)) / 2", {Level = 3})).to.equal((3 * (3+2)) / 2)
    end)
end
