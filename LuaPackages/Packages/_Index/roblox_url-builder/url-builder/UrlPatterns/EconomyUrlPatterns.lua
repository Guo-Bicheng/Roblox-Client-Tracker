return function(UrlBuilder)
	local EconomyPatterns = {
		paymentsGateway = {
			getUpsellProduct = UrlBuilder.fromString("apis:payments-gateway/v1/products/get-upsell-product"),
		},
		purchaseWarning = {
			getPurchaseWarning = function(mobileProductId: string?, productId: number?, is13To17ScaryModalEnabled: bool?)
				local baseURL: string = "apis:purchase-warning/v1/purchase-warnings"
				local url: string = ""

				if mobileProductId ~= nil then
					url = string.format("%s?mobileProductId=%s", baseURL, mobileProductId)
				elseif productId ~= nil then 
					url = string.format("%s?productId=%d", baseURL, productId)
				else
					warn(string.format("%s - Invalid parameters, needs mobileProductId or productId", tostring(script.name)))
					return nil
				end

				if is13To17ScaryModalEnabled then
					url = string.format("%s&is13To17ScaryModalEnabled=True", url)
				end
				
				return UrlBuilder.fromString(url)()
			end,
			ackPurchaseWarning = UrlBuilder.fromString("apis:purchase-warning/v1/purchase-warnings/acknowledge"),
		}
	}

	return EconomyPatterns
end
