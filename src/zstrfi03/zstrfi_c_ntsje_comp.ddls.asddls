@EndUserText.label: '[FI] 세금계산서 대사'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZSTRFI_C_NTSJE_COMP
  provider contract transactional_query
  as projection on ZSTRFI_R_NTSJE_COMP
{
  key HTApprvNo,

  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      HTInputDate,

      HTSupplierNo,

      HTSupplier,

      @Aggregation.default: #SUM
      HTSupplyAmount,

      @Aggregation.default: #SUM
      HTTaxAmount,

      @Aggregation.default: #SUM
      HTTotalAmount,

      @Semantics.currencyCode: true
      Currency,

      BusinessPlace,

      //AccountingDocumentType,
      Supplier,

      SupplierName,

      DocumentDate,

      PostingDate,

      @Aggregation.default: #SUM
      SupplyAmount,

      @Aggregation.default: #SUM
      TaxAmount,

      @Aggregation.default: #SUM
      TotalAmount,

      @Semantics.currencyCode: true
      TransactionCurrency,

      //SupplierTaxNum2,

      //NtsCnt,

      //JeCnt,

      @Aggregation.default: #SUM
      CalcuTotal,

      SDate,

      SSuplierNo
}
