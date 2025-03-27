import Foundation

public class RTPSData: @unchecked Sendable {
    public var financingType: BreadPartnersFinancingType?
    public var order: Order?
    public var locationType: BreadPartnersLocationType?
    public var cardType: String?
    public var country: String?
    public var prescreenId: Int?
    public var correlationData: String?
    public var customerAcceptedOffer: Bool?
    public var channel: String?
    public var subChannel: String?
    public var mockResponse: BreadPartnersMockOptions?

    public init(
        financingType: BreadPartnersFinancingType? = nil, order: Order? = nil,
        locationType: BreadPartnersLocationType? = nil, cardType: String? = nil,
        country: String? = nil, prescreenId: Int? = nil,
        correlationData: String? = nil,
        customerAcceptedOffer: Bool? = nil, channel: String? = nil,
        subChannel: String? = nil,
        mockResponse: BreadPartnersMockOptions? = nil
    ) {
        self.financingType = financingType
        self.order = order
        self.locationType = locationType
        self.cardType = cardType
        self.country = country
        self.prescreenId = prescreenId
        self.correlationData = correlationData
        self.customerAcceptedOffer = customerAcceptedOffer
        self.channel = channel
        self.subChannel = subChannel
        self.mockResponse = mockResponse
    }
}

public enum BreadPartnersMockOptions: String, CaseIterable, @unchecked Sendable
{
    case noMock = ""
    case success = "success"
    case noHit = "noHit"
    case makeOffer = "makeOffer"
    case ackknowledge = "ackknowledge"
    case existingAccount = "existingAccount"
    case existingOffer = "existingOffer"
    case newOffer = "newOffer"
    case error = "error"
}
