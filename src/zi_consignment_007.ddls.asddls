@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_CONSIGNMENT_007'
define root view entity ZI_CONSIGNMENT_007 as select from zconsignment007 as Consignment
composition [0..*] of ZI_ITEM_007 as _Item

{
    key consignmentuuid as ConsignmentUUID,

    consignmentid as ConsignmentID,
    messageid as MessageID,
    customerid as CustomerID,
    customername as CustomerName,
    messagedate as MessageDate,
    status as Status,
    customerurl as CustomerURL,

    createdby as CreatedBy,
    createdat as CreatedAt,
    lastchangedby as LastChangedBy,
    lastchangedat as LastChangedAt,
    locallastchangedat as LocalLastChangedAt,

    /* Associations */
    _Item
}
