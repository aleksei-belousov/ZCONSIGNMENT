@EndUserText.label: 'ZC_CONSIGNMENT_007'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_CONSIGNMENT_007 provider contract transactional_query as projection on ZI_CONSIGNMENT_007
{
    key ConsignmentUUID,
    ConsignmentID,
    MessageID,
    CustomerID,
    CustomerName,
    MessageDate,
    Status,
    CustomerURL,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,

    /* Associations */
    _Item:  redirected to composition child ZC_ITEM_007

}
