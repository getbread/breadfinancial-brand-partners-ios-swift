class RTPSRequestBuilder:@unchecked  Sendable {

    private var merchantConfiguration: MerchantConfiguration
    private var rtpsData: RTPSData
    private var token: String

    init(
        merchantConfiguration: MerchantConfiguration,
        rtpsData: RTPSData,
        reCaptchaToken: String
    ) {
        self.merchantConfiguration = merchantConfiguration
        self.rtpsData = rtpsData
        self.token = reCaptchaToken
    }

    func build() -> RTPSRequest {
        let buyer = merchantConfiguration.buyer

        if rtpsData.prescreenId == nil {
            return RTPSRequest(
                urlPath: "screenname",
                firstName: buyer?.givenName,
                lastName: buyer?.familyName,
                address1: buyer?.billingAddress?.address1,
                city: buyer?.billingAddress?.region,
                state: buyer?.billingAddress?.locality,
                zip: buyer?.billingAddress?.postalCode,
                storeNumber: merchantConfiguration.storeNumber,
                location: rtpsData.locationType?.rawValue,
                channel: merchantConfiguration.channel,
                subchannel: merchantConfiguration.subchannel,
                reCaptchaToken: token,
                mockResponse: rtpsData.mockResponse?.rawValue,
                overrideConfig: RTPSRequest.OverrideConfig(
                    enhancedPresentment: true)
            )
        } else {
            return RTPSRequest(
                urlPath: "screenname",
                location: rtpsData.locationType?.rawValue,
                channel: merchantConfiguration.channel,
                subchannel: merchantConfiguration.subchannel,
                mockResponse: rtpsData.mockResponse?.rawValue,
                overrideConfig: RTPSRequest.OverrideConfig(
                    enhancedPresentment: true),
                prescreenId: String(rtpsData.prescreenId!)
            )
        }

    }
}
