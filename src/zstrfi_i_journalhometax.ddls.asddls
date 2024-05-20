@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALHOMETAX
  as select from zstrtfi0030
  association to ZSTRFI_I_JOURNALENTRY03 as _JournalEntry on  $projection.HTInputDate   = _JournalEntry.DocumentDate
                                                          and $projection.HTSupplierNo  = _JournalEntry.SupplierTaxNum2
                                                          and $projection.HTTotalAmount = _JournalEntry.TotalAmount
{
  key ntsinputdate                                                                               as HTInputDate,

  key ntsapprvno                                                                                 as HTApprvNo,

  key ntssupplierno                                                                              as HTSupplierNo,

      @Semantics.amount.currencyCode: 'Currency'
  key ntsnetamount                                                                               as HTSupplyAmount,

      ntssupplier                                                                                as HTSupplier,

      @Semantics.amount.currencyCode: 'Currency'
      ntstaxamount                                                                               as HTTaxAmount,

      @Semantics.amount.currencyCode: 'Currency'
      ntstotalamount                                                                             as HTTotalAmount,

      currency                                                                                   as Currency,

      _JournalEntry.CompanyCode                                                                  as CompanyCode,

      _JournalEntry.BusinessPlace                                                                as BusinessPlace,

      _JournalEntry.FiscalYear                                                                   as FiscalYear,

      _JournalEntry.AccountingDocument                                                           as AcctDoc,

      _JournalEntry.AccountingDocumentType                                                       as AcctDocType,

      _JournalEntry.DocumentDate                                                                 as DocumentDate,

      _JournalEntry.PostingDate                                                                  as PostingDate,

      _JournalEntry.TransactionCurrency                                                          as TransactionCurr,

      @Semantics.amount.currencyCode: 'TransactionCurr'
      _JournalEntry.TaxAmount                                                                    as TaxAmount,

      @Semantics.amount.currencyCode: 'TransactionCurr'
      _JournalEntry.TotalAmount                                                                  as TotalAmount,

      @Semantics.amount.currencyCode: 'TransactionCurr'
      _JournalEntry.SupplyAmount                                                                 as SupplyAmount,

      _JournalEntry.Supplier                                                                     as Supplier,

      _JournalEntry.SupplierName                                                                 as SupplierNM,

      _JournalEntry.SupplierTaxNum2                                                              as SupplierTaxNum2,

      @Semantics.amount.currencyCode: 'Currency'
      cast(ntstotalamount as abap.curr(23,2))-cast(_JournalEntry.TotalAmount as abap.curr(23,2)) as AmountDifference
}
