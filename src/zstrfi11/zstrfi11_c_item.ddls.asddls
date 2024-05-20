@EndUserText.label: '[FI] 지급 이체 요청 - 아이템 Projection BO'
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZSTRFI11_C_ITEM
  as projection on ZSTRFI11_R_ITEM as PaymentProposalItem

{
  key PaymentRunDate,
  key PaymentRunID,
  key PaymentRunIsProposal,
  key PayingCompanyCode,
  key Supplier,
  key Customer,
  key PaymentRecipient,
  key PaymentDocument,
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
      AccountingDocumentType,
      DocumentDate,
      DueCalculationBaseDate,
      PaymentMethod,
      PostingDate,
      DocumentItemText,
      GLAccount,
      TaxCode,

      @Semantics.amount.currencyCode: 'PaymentCurrency'
      AmountInTransactionCurrency,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      PaymentCurrency,

      DebitCreditCode,
      BusinessPlace,
      HouseBank,
      BankReconciliationAccount,
      ConsideredPaymentMethods,

      LocalLastChangedAt,

      /* Associations */
      _PaymentProposalPayment : redirected to parent ZSTRFI11_C_HEADER,

      _AccountingDocumentType,
      _CompanyCode,
      _Customer,
      _DebitCreditCode,
      _GLAccountInCompanyCode,
      _HouseBank,
      _OperationalAcctgDocItem,
      _PaymentCurrency,
      _Supplier

}
