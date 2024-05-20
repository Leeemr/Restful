@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_MAIN
  as select from ZSTRFI_I_NTSJE_PROC
{
  key HTApprvNo,

  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

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

      BusinessPlace,

      AccountingDocumentType,

      DocumentDate,

      PostingDate,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SupplyAmount,

      Supplier,

      SupplierName,

      SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      @Semantics.amount.currencyCode: 'Currency'
      cast(CalcuTotal as abap.curr(31, 2)) as CalcuTotal,

      HTInputDate  as SDate,

      HTSupplierNo as SSuplierNo


}
where
      NtsCnt = 1
  and JeCnt  = 1

union select from ZSTRFI_I_NTSJE_PROC
{
  key HTApprvNo,

  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      HTInputDate,

      HTSupplierNo,

      HTSupplyAmount,

      HTSupplier,

      HTTaxAmount,

      HTTotalAmount,

      Currency,

      BusinessPlace,

      AccountingDocumentType,

      DocumentDate,

      PostingDate,

      Currency                       as TransactionCurrency,

      cast( 0.00 as abap.curr(23,2)) as TaxAmount,

      cast( 0.00 as abap.curr(23,2)) as TotalAmount,

      cast( 0.00 as abap.curr(23,2)) as SupplyAmount,

      Supplier,

      SupplierName,

      SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(CalcuTotal as abap.curr(31, 2)) as CalcuTotal,

      HTInputDate                    as SDate,

      HTSupplierNo                   as SSuplierNo
}
where
  NtsCnt = 0

union select from ZSTRFI_I_JENTS_PROC
{
  key HTApprvNo,
  
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
      HTInputDate,

      HTSupplierNo,

      cast( 0.00 as abap.curr(23,2)) as HTSupplyAmount,

      HTSupplier,

      cast( 0.00 as abap.curr(23,2)) as HTTaxAmount,

      cast( 0.00 as abap.curr(23,2)) as HTTotalAmount,

      TransactionCurrency as Currency,

      BusinessPlace,

      AccountingDocumentType,

      DocumentDate,

      PostingDate,

      TransactionCurrency,

      TaxAmount,

      TotalAmount,

      SupplyAmount,

      Supplier,

      SupplierName,

      SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(CalcuTotal as abap.curr(31, 2)) as CalcuTotal,

      SDate,

      SSuplierNo
}where JeCnt = 0

union select from ZSTRFI_I_NTSJE_PROC
{
  key cast('' as abap.char(40)) as HTApprvNo,

  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      cast('00000000' as abap.dats) as HTInputDate,

      cast('' as abap.char(12)) as HTSupplierNo,

      cast( 0.00 as abap.curr(23,2)) as HTSupplyAmount,

      cast('' as abap.char(80)) as HTSupplier,

      cast( 0.00 as abap.curr(23,2)) as HTTaxAmount,

      cast( 0.00 as abap.curr(23,2)) as HTTotalAmount,

      Currency,

      BusinessPlace,

      AccountingDocumentType,

      DocumentDate,

      PostingDate,

      TransactionCurrency,

      TaxAmount,

      TotalAmount,

      SupplyAmount,

      Supplier,

      SupplierName,

      SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(TotalAmount * -1 as abap.curr(31, 2)) as CalcuTotal,

      HTInputDate                    as SDate,

      HTSupplierNo                   as SSuplierNo
}where NtsCnt > 1

union select from ZSTRFI_I_JENTS_PROC
{
  key HTApprvNo,
  
  key cast('' as abap.char(4)) as CompanyCode,
  
  key cast('' as abap.numc(4)) as FiscalYear,
  
  key cast('' as abap.char(10)) as AccountingDocument,
  
      HTInputDate,

      HTSupplierNo,

      HTSupplyAmount,

      HTSupplier,

      HTTaxAmount,

      HTTotalAmount,

      Currency,

      cast('' as abap.char(4)) as BusinessPlace,

      cast('' as abap.char(2)) as AccountingDocumentType,

      cast('00000000' as abap.dats) as DocumentDate,

      cast('00000000' as abap.dats) as PostingDate,

      TransactionCurrency,

      cast( 0.00 as abap.curr(23,2)) as TaxAmount,

      cast( 0.00 as abap.curr(23,2)) as TotalAmount,

      cast( 0.00 as abap.curr(23,2)) as SupplyAmount,

      cast('' as abap.char(10)) as Supplier,

      cast('' as abap.char(220)) as SupplierName,

      cast('' as abap.char(11)) as SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(HTTotalAmount as abap.curr(31, 2)) as CalcuTotal,

      SDate,

      SSuplierNo
}where JeCnt > 1

union select from ZSTRFI_I_NTSJE_PROC
{
  key HTApprvNo,

  key cast('' as abap.char(4)) as CompanyCode,
  
  key cast('' as abap.numc(4)) as FiscalYear,
  
  key cast('' as abap.char(10)) as AccountingDocument,
  
      HTInputDate,

      HTSupplierNo,

      HTSupplyAmount,

      HTSupplier,

      HTTaxAmount,

      HTTotalAmount,

      Currency,

      cast('' as abap.char(4)) as BusinessPlace,

      cast('' as abap.char(2)) as AccountingDocumentType,

      cast('00000000' as abap.dats) as DocumentDate,

      cast('00000000' as abap.dats) as PostingDate,

      TransactionCurrency,

      cast( 0.00 as abap.curr(23,2)) as TaxAmount,

      cast( 0.00 as abap.curr(23,2)) as TotalAmount,

      cast( 0.00 as abap.curr(23,2)) as SupplyAmount,

      cast('' as abap.char(10)) as Supplier,

      cast('' as abap.char(220)) as SupplierName,

      cast('' as abap.char(11)) as SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(HTTotalAmount as abap.curr(31, 2)) as CalcuTotal,

      HTInputDate                    as SDate,

      HTSupplierNo                   as SSuplierNo
}
where
  NtsCnt > 1 and JeCnt = 1
  
  union select from ZSTRFI_I_JENTS_PROC
{
  key cast('' as abap.char(40)) as HTApprvNo,

  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      cast('00000000' as abap.dats) as HTInputDate,

      cast('' as abap.char(12)) as HTSupplierNo,

      cast( 0.00 as abap.curr(23,2)) as HTSupplyAmount,

      cast('' as abap.char(80)) as HTSupplier,

      cast( 0.00 as abap.curr(23,2)) as HTTaxAmount,

      cast( 0.00 as abap.curr(23,2)) as HTTotalAmount,

      Currency,

      BusinessPlace,

      AccountingDocumentType,

      DocumentDate,

      PostingDate,

      TransactionCurrency,

      TaxAmount,

      TotalAmount,

      SupplyAmount,

      Supplier,

      SupplierName,

      SupplierTaxNum2,

      NtsCnt,

      JeCnt,

      cast(TotalAmount * -1 as abap.curr(31, 2)) as CalcuTotal,

      SDate,

      SSuplierNo
}where 
  JeCnt > 1 and NtsCnt = 1
