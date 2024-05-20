@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 신용카드 레포트'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZSTRFI_I_JOURNALENTRY
  as select from ZSTRFI_I_JOURNALENTRYLIST
{
      @EndUserText.label: '회사 코드'
      @Consumption.valueHelpDefinition: [{
                    entity: { name: 'I_CompanyCodeStdVH',
                    element: 'CompanyCode'} }]
  key CompanyCode,

      @EndUserText.label: '회계 연도'
      @Consumption.valueHelpDefinition: [{
              entity: { name: 'ZSTRFI_V_FISCALYEAR',
              element: 'FiscalYear'} }]
  key FiscalYear,

      @EndUserText.label: '분개'
  key AccountingDocument,

      AccountingDocumentType,

      @EndUserText.label: '매수'
      CountLine,

      case
        when length(_SupplyPrice.AssignmentReference) <> 10
          or instr( _SupplyPrice.AssignmentReference, '-' ) <> 0
          then 1
        else
          ErrorCheck
       end                              as ErrorCheck,

      @EndUserText.label: '회계 기간'
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZSTRFI_V_FISCALPERIOD',
        element: 'FiscalPeriod'} }]
      FiscalPeriod,

      @EndUserText.label: '거래 일자'
      @Consumption.filter.selectionType: #INTERVAL
      PostingDate,

      PostingKey,

      IsReversal,

      DocumentDate,

      TransactionCurrency,

      CompanyCodeName,

      AccountingDocumentTypeName,

      @EndUserText.label: '공급 업체'
      _AP.Supplier,

      @EndUserText.label: '공급업체명'
      _AP.SupplierFullName,

      @EndUserText.label: '부채'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      - _AP.AmountInTransactionCurrency as APAmountInTransactionCurrency,

      _AP.CompanyCodeCurrency           as APCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'APCompanyCodeCurrency'
      - _AP.AmountInCompanyCodeCurrency as APAmountInCompanyCodeCurrency,

      @EndUserText.label: '세액'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
        when _Tax.AmountInTransactionCurrency is null
         then
          cast(0 as abap.curr(23,2))
        else
          _Tax.AmountInTransactionCurrency
      end                               as TaxAmountInTransactionCurrency,

      _Tax.CompanyCodeCurrency          as TaxCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'TaxCompanyCodeCurrency'
      case
       when _Tax.AmountInCompanyCodeCurrency is null
        then
         cast(0 as abap.curr(23,2))
       else
         _Tax.AmountInCompanyCodeCurrency
      end                               as TaxAmountInCompanyCodeCurrency,

      @EndUserText.label: '세금 코드'
      _Tax.TaxCode,

      _Tax.TransactionTypeDetermination,

      @EndUserText.label: '공급가액'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
        when _Tax.AmountInTransactionCurrency is null
         then
          - _AP.AmountInTransactionCurrency
        else
          - _AP.AmountInTransactionCurrency - _Tax.AmountInTransactionCurrency
      end                               as SupplyAmountInTranCurrency,

      _SupplyPrice.CompanyCodeCurrency  as SupplyCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
       when _Tax.AmountInCompanyCodeCurrency is null
        then
         - _AP.AmountInCompanyCodeCurrency
       else
         - _AP.AmountInCompanyCodeCurrency - _Tax.AmountInCompanyCodeCurrency
      end                               as SupplyAmountInCompCdCurr,

      @EndUserText.label: '사업자 등록번호'
      _SupplyPrice.AssignmentReference,

      _SupplyPrice.DocumentItemText
}
where
     _Tax.TaxCode = 'V3'
  or _Tax.TaxCode = 'V7'
