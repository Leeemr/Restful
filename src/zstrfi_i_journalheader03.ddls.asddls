@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALHEADER03
  as select from I_JournalEntry
  association to I_SupplierInvoiceAPI01 as _SupplierInvoice on $projection.OriginalReferenceDocument = _SupplierInvoice.SupplierInvoiceWthnFiscalYear
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      Branch,
      DocumentDate,
      PostingDate,
      FiscalPeriod,
      OriginalReferenceDocument,
      IsReversal,
      IsReversed,
      _SupplierInvoice.BusinessPlace,
      /* Associations */
      _AccountingDocumentType,
      _AccountingDocumentTypeText,
      _AddlLedgerOplAcctgDocItem,
      _CompanyCode,
      _FiscalPeriod,
      _FiscalYear,
      _JournalEntryItem,
      _OperationalAcctgDocItem
}
