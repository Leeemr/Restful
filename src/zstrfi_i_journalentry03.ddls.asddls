@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALENTRY03
  as select from ZSTRFI_I_JOURNALHEADER03
  association to ZSTRFI_I_JOURNALTOTAL03 as _JournalTotal on  $projection.CompanyCode        = _JournalTotal.CompanyCode
                                                          and $projection.FiscalYear         = _JournalTotal.FiscalYear
                                                          and $projection.AccountingDocument = _JournalTotal.AccountingDocument

  association to ZSTRFI_I_JOURNALTAX03   as _JournalTax   on  $projection.CompanyCode        = _JournalTax.CompanyCode
                                                          and $projection.FiscalYear         = _JournalTax.FiscalYear
                                                          and $projection.AccountingDocument = _JournalTax.AccountingDocument
{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      AccountingDocumentType,
      
      BusinessPlace,

      DocumentDate,

      PostingDate,

      _JournalTotal.TransactionCurrency                                        as TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalTax.TaxAmount                                                    as TaxAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalTotal.TotalAmount * -1                                           as TotalAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
        when _JournalTax.TaxAmount is null
         then _JournalTotal.TotalAmount * -1
        else
         -cast(_JournalTotal.TotalAmount as abap.curr(23,2))-cast(_JournalTax.TaxAmount as abap.curr(23,2)) 
      end as SupplyAmount,

      _JournalTotal.Supplier,

      _JournalTotal.SupplierName,
      
      _JournalTotal.SupplierTaxNum2,
          
      _JournalTotal,
      _JournalTax
}where 
   _JournalTotal.TotalAmount is not initial 
   and (    AccountingDocumentType = 'KR'
         or AccountingDocumentType = 'RE')
