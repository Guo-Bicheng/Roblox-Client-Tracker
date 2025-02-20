--!nonstrict
--[[
	Model for an Asset (e.g. Hat).
	{
		name = string,
		assetId = string,
		assetTypeId = string,
		creatorId = string,
		creatorName = string,
		owned = bool,
		isForSale = bool,
		description = string,
		price = string,
		productId = string,
		isLimited = bool,
		bundlesAssetIsIn = table,
		numFavorites = int,
	}
]]
local CoreGui = game:GetService("CoreGui")

local MockId = require(script.Parent.Parent.MockId)

local FFlagEnableRestrictedAssetSaleLocationInspectAndBuy
	= require(CoreGui.RobloxGui.Modules.Flags.FFlagEnableRestrictedAssetSaleLocationInspectAndBuy)
local FFlagShowVerifiedBadgeOnInspectAndBuyDetails =
	require(CoreGui.RobloxGui.Modules.InspectAndBuy.Flags.FFlagShowVerifiedBadgeOnInspectAndBuyDetails)

local AssetInfo = {}

function AssetInfo.new()
	local self = {}

	return self
end

function AssetInfo.mock()
	local self = AssetInfo.new()

	self.name = ""
	self.assetId = MockId()
	self.assetTypeId = ""
	self.creatorId = ""
	self.creatorName = ""
	self.creatorHasVerifiedBadge = false
	self.owned = false
	self.isForSale = false
	self.description = ""
	self.price = ""
	self.productId = ""
	self.isLimited = false
	self.bundlesAssetIsIn = {}
	self.numFavorites = 0
	self.minimumMembershipLevel = 0

	return self
end

function AssetInfo.fromGetProductInfo(assetInfo)
	local newAsset = AssetInfo.new()

	newAsset.name = assetInfo.Name
	newAsset.description = assetInfo.Description
	newAsset.price = assetInfo.PriceInRobux
	newAsset.creatorId = tostring(assetInfo.Creator.Id)
	newAsset.creatorName = assetInfo.Creator.Name
	newAsset.assetId = tostring(assetInfo.AssetId)
	newAsset.assetTypeId = tostring(assetInfo.AssetTypeId)
	newAsset.productId = tostring(assetInfo.ProductId)
	if FFlagEnableRestrictedAssetSaleLocationInspectAndBuy then
		newAsset.isForSale = assetInfo.isForSale and assetInfo.CanBeSoldInThisGame
	else
		newAsset.isForSale = assetInfo.IsForSale
	end
	if FFlagShowVerifiedBadgeOnInspectAndBuyDetails() then
		newAsset.creatorHasVerifiedBadge = assetInfo.Creator.HasVerifiedBadge
	end
	newAsset.isLimited = assetInfo.IsLimited or assetInfo.IsLimitedUnique

	return newAsset
end

function AssetInfo.fromHumanoidDescription(id)
	local newAsset = AssetInfo.new()

	newAsset.assetId = tostring(id)

	return newAsset
end

function AssetInfo.fromGetAssetBundles(assetId, bundleIds)
	local newAsset = AssetInfo.new()
	newAsset.assetId = tostring(assetId)
	newAsset.bundlesAssetIsIn = bundleIds
	return newAsset
end

function AssetInfo.fromGetAssetFavoriteCount(assetId, numFavorites)
	local newAsset = AssetInfo.new()

	newAsset.assetId = tostring(assetId)
	newAsset.numFavorites = numFavorites

	return newAsset
end

function AssetInfo.fromGetEconomyProductInfo(asset, isOwned, price, isForSale, premiumPricing)
	local newAsset = AssetInfo.new()

	newAsset.assetId = tostring(asset.assetId)
	newAsset.owned = isOwned
	if price then
		newAsset.price = price
	end
	newAsset.isForSale = isForSale
	newAsset.premiumPricing = premiumPricing

	return newAsset
end

function AssetInfo.fromPurchaseSuccess(assetId)
	local newAsset = AssetInfo.new()
	newAsset.assetId = tostring(assetId)
	newAsset.owned = true
	return newAsset
end

return AssetInfo
