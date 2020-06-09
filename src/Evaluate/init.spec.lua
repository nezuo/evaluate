return function()
    local Evaluation = require(script.Parent)

    it("should add 1 to 1", function()
        expect(Evaluation("1 + 1")).to.equal(1 + 1)
    end)

    it("should subtract 1 from 1", function()
        expect(Evaluation("1 - 1")).to.equal(1 - 1)
    end)

    it("should multiply 2 by 2", function()
        expect(Evaluation("2 * 2")).to.equal(2 * 2)
    end)

    it("should divide 8 by 2", function()
        expect(Evaluation("8 / 2")).to.equal(8 / 2)
    end)

    it("should take 8 to the power of 2", function()
        expect(Evaluation("8 ^ 2")).to.equal(8 ^ 2)
    end)

    it("should take 8 modulo 2", function()
        expect(Evaluation("8 % 2")).to.equal(8 % 2)
    end)

    it("should solve abs", function()
        expect(Evaluation("abs(0-4)")).to.equal(math.abs(-4))
    end)

    it("should solve acos", function()
        expect(Evaluation("acos(0)")).to.equal(math.acos(0))
    end)

    it("should solve asin", function()
        expect(Evaluation("asin(1)")).to.equal(math.asin(1))
    end)

    it("should solve atan", function()
        expect(Evaluation("atan(4)")).to.equal(math.atan(4))
    end)

    it("should solve ceil", function()
        expect(Evaluation("ceil(2.2)")).to.equal(math.ceil(2.2))
    end)

    it("should solve cos", function()
        expect(Evaluation("cos(4)")).to.equal(math.cos(4))
    end)

    it("should solve cosh", function()
        expect(Evaluation("cosh(4)")).to.equal(math.cosh(4))
    end)

    it("should solve deg", function()
        expect(Evaluation("deg(1.3)")).to.equal(math.deg(1.3))
    end)

    it("should solve exp", function()
        expect(Evaluation("exp(1.3)")).to.equal(math.exp(1.3))
    end)

    it("should solve floor", function()
        expect(Evaluation("floor(1.3)")).to.equal(math.floor(1.3))
    end)

    it("should solve rad", function()
        expect(Evaluation("rad(90)")).to.equal(math.rad(90))
    end)

    it("should solve sign", function()
        expect(Evaluation("sign(4)")).to.equal(math.sign(4))
    end)

    it("should solve sin", function()
        expect(Evaluation("sin(4)")).to.equal(math.sin(4))
    end)

    it("should solve sinh", function()
        expect(Evaluation("sinh(4)")).to.equal(math.sinh(4))
    end)

    it("should solve sqrt", function()
        expect(Evaluation("sqrt(4)")).to.equal(math.sqrt(4))
    end)

    it("should solve tan", function()
        expect(Evaluation("tan(4)")).to.equal(math.tan(4))
    end)

    it("should solve tanh", function()
        expect(Evaluation("tanh(4)")).to.equal(math.tanh(4))
    end)

    it("should solve correctly x1", function()
        expect(Evaluation("5 + ((1 + 2) * 4) - 3")).to.equal(5 + ((1 + 2) * 4) - 3)
    end)

    it("should solve correctly x2", function()
        expect(Evaluation("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3)
    end)

    it("should solve correctly x3", function()
        expect(Evaluation("3 + 4 ^ 3 * 2 % 4 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(3 + 4 ^ 3 * 2 % 4 / ( 1 - 5 ) ^ 2 ^ 3)
    end)

    it("should solve correctly x4", function()
        expect(Evaluation("4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3")).to.equal(4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3)
    end)

    it("should solve correctly x5", function()
        expect(Evaluation("sqrt(4) + 3")).to.equal(math.sqrt(4) + 3)
    end)

    it("should solve correctly x6", function()
        expect(Evaluation("sqrt(4 + 5 * 3) + sin(0.5)")).to.equal(math.sqrt(4 + 5 * 3) + math.sin(0.5))
    end)
end