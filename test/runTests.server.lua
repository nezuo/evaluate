local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.Vendor.TestEZ)

TestEZ.TestBootstrap:run({ ReplicatedStorage.evaluate })
