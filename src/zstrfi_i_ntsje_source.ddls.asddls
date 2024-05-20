@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_SOURCE
  as select from ZSTRFI_I_HOMETAX
  association to ZSTRFI_I_JOURNALENTRY03 as _JournalEntry on  $projection.HTInputDate   = _JournalEntry.DocumentDate
                                                          and $projection.HTSupplierNo  = _JournalEntry.SupplierTaxNum2
                                                          and $projection.HTTotalAmount = _JournalEntry.TotalAmount
                                                          
{
  key HTApprvNo,
  
  key _JournalEntry.CompanyCode,
  
  key _JournalEntry.FiscalYear,

  key _JournalEntry.AccountingDocument,
      
      HTInputDate,
      
      HTSupplierNo,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTSupplyAmount,
      
      HTSupplier,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTTaxAmount,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTTotalAmount,
      
      Currency,

      _JournalEntry.BusinessPlace,

      _JournalEntry.AccountingDocumentType,

      _JournalEntry.DocumentDate,

      _JournalEntry.PostingDate,

      _JournalEntry.TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalEntry.TaxAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalEntry.TotalAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalEntry.SupplyAmount,

      _JournalEntry.Supplier,

      _JournalEntry.SupplierName,

      _JournalEntry.SupplierTaxNum2
}
