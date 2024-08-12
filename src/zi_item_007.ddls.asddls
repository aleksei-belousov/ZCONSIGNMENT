@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_ITEM_007'
define view entity ZI_ITEM_007 as select from zitem007
association to parent ZI_CONSIGNMENT_007 as _Consignment on $projection.ConsignmentUUID = _Consignment.ConsignmentUUID

{
    key itemuuid as ItemUUID,
    itemid as ItemID,
    consignmentuuid as ConsignmentUUID,
    productid as ProductID,
    productname as ProductName,
    quantity as Quantity,
    quantityunit as QuantityUnit,
    noinventory as NoInventory,
    producturl as ProductURL,
    createdby as CreatedBy,
    createdat as CreatedAt,
    lastchangedby as LastChangedBy,
    lastchangedat as LastChangedAt,
    locallastchangedat as LocalLastChangedAt,
    
    _Consignment // Make association public
}
