local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Roact)
local LocalizationRoactContext = require(script.Parent.LocalizationRoactContext)

local function LocalizationProvider(props)
	return Roact.createElement(LocalizationRoactContext.Provider, {
		value = props.localization
	}, props[Roact.Children])
end

return LocalizationProvider
