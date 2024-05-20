@EndUserText.label: '[FI] 지급 이체 요청 - 헤더 Projection BO'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'Supplier' ]

define root view entity ZSTRFI11_C_HEADER
  provider contract transactional_query
  as projection on ZSTRFI11_R_HEADER as PaymentProposalPayment
{
      //      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false }
  key PaymentRunDate,
  key PaymentRunID,
  key PaymentRunIsProposal,
      @Search.defaultSearchElement: true
  key PayingCompanyCode,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier', element: 'Supplier'} }]
  key Supplier,
  key Customer,
  key PaymentRecipient,
  key PaymentDocument,
      PayeeName,

      PayeeMatch,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZSTRFI11_VH_MATCH', element: 'value_low' } }]
      @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false }
      PayeeMatchStatus,
      PayeeMatchCriticality,

      APITrans,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZSTRFI11_VH_API', element: 'value_low' } }]
      @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false }
      APITransStatus,
      APITransStatusCriticality,

      CheckBalance,
      ProcessResult,

      ReverseDocument,
      ReverseDocumentStatus,

      ISSUENO,

      //      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false }
      PaymentDueDate,
      PostingDate,

      @Semantics.amount.currencyCode: 'PaymentCurrency'
      PaymentAmountInFunctionalCrcy,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      PaymentCurrency,

      PayeeBankAccount,
      PayeeBankAccountHolderName,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _PaymentProposalItem : redirected to composition child ZSTRFI11_C_ITEM,

      _Supplier,

      _CompanyCode,
      _PaymentCurrency

}
