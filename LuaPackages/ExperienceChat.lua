--!nonstrict
local CorePackages = game:GetService("CorePackages")

local initify = require(CorePackages.initify)
local GetFFlagUpgradeExpChatV3_3_1 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUpgradeExpChatV3_3_1

initify(CorePackages.Packages)

if GetFFlagUpgradeExpChatV3_3_1() then
    return require(CorePackages.Packages.ExperienceChat_New)
else
    return require(CorePackages.Packages.ExperienceChat)
end
