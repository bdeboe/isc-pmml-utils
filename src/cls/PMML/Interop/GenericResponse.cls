/// Generic Response class for <Class>BusinessOperation</Class>
Class PMML.Interop.GenericResponse Extends (%Persistent, Ens.Response)
{

/// Primary output value predicted by the model
Property PredictedValue As %String;

/// Array containing all output values produced by the model
Property ModelOutput As array Of %String;

Storage Default
{
<Data name="GenericResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PredictedValue</Value>
</Value>
</Data>
<Data name="ModelOutput">
<Attribute>ModelOutput</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelOutput"</Subscript>
</Data>
<DataLocation>^PMML.Interop.GenericResponseD</DataLocation>
<DefaultData>GenericResponseDefaultData</DefaultData>
<IdLocation>^PMML.Interop.GenericResponseD</IdLocation>
<IndexLocation>^PMML.Interop.GenericResponseI</IndexLocation>
<StreamLocation>^PMML.Interop.GenericResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}