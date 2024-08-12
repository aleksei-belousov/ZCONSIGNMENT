@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status'
define root view entity ZI_STATUS_007 as select from zstatus007 as Status
{
    key status as Status,
    createdby as Createdby,
    createdat as Createdat,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    locallastchangedat as Locallastchangedat
}
