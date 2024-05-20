@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표헤더'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALHEADER
  as select from I_JournalEntry
  association [0..1] to I_Currency as _Currency on $projection.TransactionCurrency = _Currency.Currency
{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      AccountingDocumentType,
      
      FiscalPeriod,

      PostingDate,

      DocumentDate,

      TransactionCurrency,

      IsReversed,

      IsReversal,

      _CompanyCode,

      _AccountingDocumentType,

      _Currency
}
