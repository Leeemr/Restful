@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
define root view entity ZSTRFI_R_JOURNALENTRY03
  as select from ZSTRFI_I_JOURNALENTRY03
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      BusinessPlace,
      DocumentDate,
      PostingDate,
      TransactionCurrency,
      TaxAmount,
      TotalAmount,
      Supplier,
      SupplierName,
      SupplierTaxNum2,
      /* Associations */
      _JournalTotal
}
