//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 신용카드 레포트'
@Metadata.allowExtensions: true

define view entity ZSTRFI_C_JOURNALENTRY
  as select from ZSTRFI_I_JOURNALENTRY
{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      AccountingDocumentType,

      FiscalPeriod,

      @Aggregation.default: #SUM
      CountLine,

      PostingDate,
      
      ErrorCheck,

      DocumentDate,

      TransactionCurrency,

      CompanyCodeName,

      AccountingDocumentTypeName,

      Supplier,

      SupplierFullName,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      APAmountInTransactionCurrency,

      APCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'APCompanyCodeCurrency'
      APAmountInCompanyCodeCurrency,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmountInTransactionCurrency,

      TaxCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'TaxCompanyCodeCurrency'
      TaxAmountInCompanyCodeCurrency,

      TaxCode,

      TransactionTypeDetermination,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SupplyAmountInTranCurrency,

      SupplyCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'SupplyCompanyCodeCurrency'
      SupplyAmountInCompCdCurr,


      AssignmentReference,

      DocumentItemText

}
