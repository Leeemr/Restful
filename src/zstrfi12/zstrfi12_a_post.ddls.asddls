@EndUserText.label: 'Popup'
@Metadata.allowExtensions: true
define abstract entity zstrfi12_a_post
{
  @EndUserText.label: 'Customer'
  @Consumption.valueHelpDefinition: [{ entity.name: 'I_Customer', entity.element: 'Customer' }]      
  zkunnr        : abap.char(10);
  
//  @UI.adaptationHidden: true
//  md_customer_name  : abap.char(80);  
 
}
