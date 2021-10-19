return function()
	local evaluate = require(script.Parent)

	it("should return 10", function()
		expect(evaluate("10")).to.equal(10)
	end)

	it("should return -10", function()
		expect(evaluate("-10")).to.equal(-10)
	end)

	it("should return +10", function()
		expect(evaluate("+10")).to.equal(10)
	end)

	it("should add 1 to 2", function()
		expect(evaluate("1 + 2")).to.equal(1 + 2)
	end)

	it("should subtract 1 from 3", function()
		expect(evaluate("3 - 1")).to.equal(3 - 1)
	end)

	it("should multiply 2 by 3", function()
		expect(evaluate("2 * 3")).to.equal(2 * 3)
	end)

	it("should divide 9 by 2", function()
		expect(evaluate("9 / 2")).to.equal(9 / 2)
	end)

	it("should take 3 to the power of 2", function()
		expect(evaluate("3 ^ 2")).to.equal(3 ^ 2)
	end)

	it("should take 5 modulo 2", function()
		expect(evaluate("5 % 2")).to.equal(5 % 2)
	end)

	it("should evaluate inner expression", function()
		expect(evaluate("(((((5 + 4 * 2)))))")).to.equal(5 + 4 * 2)
	end)

	it("should evaluate function", function()
		expect(evaluate("abs(-4)")).to.equal(4)
	end)

	it("should evaluate function with multiple arguments", function()
		expect(evaluate("min(2, 4, 1, 5, 3, 10)")).to.equal(math.min(2, 4, 1, 5, 3, 10))
	end)

	it("should solve composite functions", function()
		expect(evaluate("pow(4, max(5, clamp(10, 1, 3)))")).to.equal(math.pow(4, math.max(5, math.clamp(10, 1, 3))))
	end)

	it("should evaluate constant", function()
		expect(evaluate("pi")).to.equal(math.pi)
	end)

	it("should evaluate variable", function()
		expect(evaluate("foo", { foo = 5 })).to.equal(5)
	end)

	it("should use variable instead of constant", function()
		expect(evaluate("pi", { pi = 6 })).to.equal(6)
	end)

	it("should evaluate correctly", function()
		expect(evaluate("5 + ((1 + 2) * 4) - 3")).to.equal(5 + ((1 + 2) * 4) - 3)
		expect(evaluate("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(3 + 4 * 2 / (1 - 5) ^ 2 ^ 3)
		expect(evaluate("10 + 4 ^ 3 * 2 % 4 / ( 1 - 5 ) ^ 2 ^ 3")).to.equal(10 + 4 ^ 3 * 2 % 4 / (1 - 5) ^ 2 ^ 3)
		expect(evaluate("4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3")).to.equal(4 + 4.5 ^ 3 * 2 ^ 2.2 ^ 3)
		expect(evaluate("sqrt(4) + 3")).to.equal(math.sqrt(4) + 3)
		expect(evaluate("1+sqrt(4)")).to.equal(1 + math.sqrt(4))
		expect(evaluate("sin(0.5) + sqrt(4 + 5 * 3)")).to.equal(math.sin(0.5) + math.sqrt(4 + 5 * 3))
		expect(evaluate("sin(0.5) + var", { var = 2.35 })).to.equal(math.sin(0.5) + 2.35)
		expect(evaluate("var1*var2", { var1 = 3, var2 = 5 })).to.equal(3 * 5)
		expect(evaluate("(3 * (foo+2)) / 2", { foo = 3 })).to.equal((3 * (3 + 2)) / 2)
	end)

	it("should throw when input is empty", function()
		expect(function()
			evaluate("")
		end).to.throw("Input empty")
	end)

	it("should throw when unary has no value", function()
		expect(function()
			evaluate("-")
		end).to.throw("Expected value after unary")
	end)

	it("should throw when parentheses are empty", function()
		expect(function()
			evaluate("()")
		end).to.throw("Expected value within parentheses")
	end)

	it("should throw when binary operation has no right hand side", function()
		expect(function()
			evaluate("1 + ")
		end).to.throw("Expected value after +")
	end)

	it("should throw when variable does not exist", function()
		expect(function()
			evaluate("foo")
		end).to.throw("'foo' is not defined")
	end)

	it("should throw when function does not exist", function()
		expect(function()
			evaluate("foo()")
		end).to.throw("'foo' is not defined")
	end)

	it("should throw when there is no closing parenthesis", function()
		expect(function()
			evaluate("(5")
		end).to.throw("Expected Close Parenthesis")
	end)

	it("should throw when function has no close parenthesis", function()
		expect(function()
			evaluate("rad(5")
		end).to.throw("Expected Close Parenthesis")
	end)

	it("should throw when it encounters an unknown sequence", function()
		expect(function()
			evaluate("1+2&")
		end).to.throw("Unexpected sequence: &")
	end)
end
