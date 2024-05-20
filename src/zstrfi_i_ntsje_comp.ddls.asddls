@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_COMP
  as select from ZSTRFI_I_NTSJE_MAIN
{
      @EndUserText.label: '사업자코드'
  key HTApprvNo,
      
      @EndUserText.label: '회사코드'
  key CompanyCode,
      
      @EndUserText.label: '회계년도'
  key FiscalYear,
      
      @EndUserText.label: '분개'
  key AccountingDocument,
      
      @EndUserText.label: '작성일자'
      HTInputDate,
      
      @EndUserText.label: '홈텍스 - 승인번호'
      HTSupplierNo,
      
      @EndUserText.label: '상호'
      HTSupplier,
      
      @EndUserText.label: '홈텍스 - 공급가액'
      @Semantics.amount.currencyCode: 'Currency'
      HTSupplyAmount,
      
      @EndUserText.label: '홈텍스 - 세액'
      @Semantics.amount.currencyCode: 'Currency'
      HTTaxAmount,
      
      @EndUserText.label: '홈텍스 - 총금액'
      @Semantics.amount.currencyCode: 'Currency'
      HTTotalAmount,
      
      @EndUserText.label: '홈텍스 - 통화'
      Currency,
      
      @EndUserText.label: '사업장'
      BusinessPlace,
      
      AccountingDocumentType,
      
      Supplier,
      
      SupplierName,
      
      @EndUserText.label: '증빙일'
      DocumentDate,
      
      @EndUserText.label: '전기일'
      PostingDate,
      
      @EndUserText.label: 'SAP - 공급가액'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SupplyAmount,
      
      @EndUserText.label: 'SAP - 세액'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,
      
      @EndUserText.label: 'SAP - 총금액'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalAmount,
      
      @EndUserText.label: 'SAP - 통화'
      TransactionCurrency,
      
      SupplierTaxNum2,
      
      NtsCnt,
      
      JeCnt,
      
      @EndUserText.label: '차이 - 총금액'
      @Semantics.amount.currencyCode: 'Currency'
      CalcuTotal,
      
      @EndUserText.label: '작성일자'
      SDate,
      
      @EndUserText.label: '사업자코드'
      SSuplierNo
}
