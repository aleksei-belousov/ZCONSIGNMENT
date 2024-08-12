@EndUserText.label: 'ZC_STATUS_007'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_STATUS_007  provider contract transactional_query as projection on ZI_STATUS_007 as Status
{
    key Status,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Locallastchangedat
}
