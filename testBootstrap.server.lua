--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--< Modules >--
local TestEZ = require(ReplicatedStorage.TestEZ)

--< Start >--
TestEZ.TestBootstrap:run({ ReplicatedStorage.Evaluate })