/// Generic request class for <Class>BusinessOperation</Class>
Class PMML.Interop.GenericRequest Extends (%Persistent, Ens.Request)
{

/// Some PMML definitions contain multiple models. 
/// Use this parameter to identify which one to run.
Property ModelName As %String(MAXLEN = 250);

/// Array of string values containing model input values
Property ModelData As array Of %String;

Storage Default
{
<Data name="GenericRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelName</Value>
</Value>
</Data>
<Data name="ModelData">
<Attribute>ModelData</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelData"</Subscript>
</Data>
<DataLocation>^PMML.Interop.GenericRequestD</DataLocation>
<DefaultData>GenericRequestDefaultData</DefaultData>
<IdLocation>^PMML.Interop.GenericRequestD</IdLocation>
<IndexLocation>^PMML.Interop.GenericRequestI</IndexLocation>
<StreamLocation>^PMML.Interop.GenericRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}