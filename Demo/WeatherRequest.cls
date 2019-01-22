Class Demo.WeatherRequest Extends (%Persistent, Ens.Request)
{

Property outlook As %String(VALUELIST=",sunny,overcast,rain") [ InitialExpression = "sunny"];
Property temperature As %Integer [ InitialExpression = 67 ];
Property humidity As %Integer(MINVAL=0,MAXVAL=100) [ InitialExpression = 25 ];
Property windy As %String(VALUELIST=",true,false") [ InitialExpression = "false"];

Storage Default
{
<Data name="WeatherRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>outlook</Value>
</Value>
<Value name="3">
<Value>temperature</Value>
</Value>
<Value name="4">
<Value>humidity</Value>
</Value>
<Value name="5">
<Value>windy</Value>
</Value>
</Data>
<DataLocation>^Demo.WeatherRequestD</DataLocation>
<DefaultData>WeatherRequestDefaultData</DefaultData>
<IdLocation>^Demo.WeatherRequestD</IdLocation>
<IndexLocation>^Demo.WeatherRequestI</IndexLocation>
<StreamLocation>^Demo.WeatherRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}