/// <p>This Business Operation allows executing a predictive model expressed as PMML. 
/// This class is abstract. Either use <Class>BusinessOperation</Class> and configure it to refer to a 
/// valid <Class>%DeepSee.PMML.Definition</Class> class through a setting, or use 
/// <Class>Utils</Class> to generate a subclass with dedicated request and response classes.</p>
/// <p>See also <a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=APMML">https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=APMML</a></p>
Class PMML.Interop.AbstractBusinessOperation Extends Ens.BusinessOperation [ Abstract ]
{

/// We can run models without a queue
Parameter INVOCATION = "InProc";

/// Local cache of model objects, saving model instantiation overhead between calls
Property ModelInstances As array Of %DeepSee.PMML.Model.AbstractModel [ Private ];

/// Utility method for invoking a model <Var>pModelName</Var> of the "current" PMML class.
/// Model input may be passed in as a <Class>%DeepSee.PMML.ModelInput</Class> instance or simple array of values.
/// Automatically instantiates an object and caches it into <Property>ModelInstances</Property>.
Method InvokeModel(pModelName As %String, ByRef pModelInput As %DeepSee.PMML.ModelInput, Output pModelOutput As %DeepSee.PMML.ModelOutput) [ Private, final ]
{
	set tModel = ..ModelInstances.GetAt(pModelName)
	if tModel = "" {
		set tSC = ..GetModelInstance(pModelName, .tModel)
		quit:$$$ISERR(tSC) tSC
		do ..ModelInstances.SetAt(tModel, "MiningModel")
	}
	quit tModel.%ExecuteModel(.pModelInput, .pModelOutput)
}

/// Utility method for instantiating a model from the current PMML definition
Method GetModelInstance(pModelName As %String, Output pModel As %DeepSee.PMML.Model.AbstractModel) As %Status [ Abstract, Private ]
{
}

Method Reset() As %Status
{
	do ..ModelInstances.Clear()
	quit $$$OK
}

}