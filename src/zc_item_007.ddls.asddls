@EndUserText.label: 'ZC_ITEM_007'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZC_ITEM_007 as projection on ZI_ITEM_007
{
    key ItemUUID,
    ItemID,
    ConsignmentUUID,
    ProductID,
    ProductName,
    Quantity,
    QuantityUnit,
    NoInventory,
    ProductURL,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    
    /* Associations */
    _Consignment : redirected to parent ZC_CONSIGNMENT_007
}
