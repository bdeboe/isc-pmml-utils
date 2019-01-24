/// This Business Operation enables running a predictive model expressed as PMML in the
/// <Class>%DeepSee.PMML.Definition</Class> class configured through <Property>PMMLClassName</Property>.
Class PMML.Interop.BusinessOperation Extends AbstractBusinessOperation
{

/// Classname of the <Class>%DeepSee.PMML.Definition</Class> subclass holding the PMML 
/// model definitions to use for this BO.
Property PMMLClassName As %String(MAXLEN = 250);

Parameter SETTINGS = "PMMLClassName:PMML:selector?context={Ens.ContextSearch/SubclassOf?class=%25DeepSee.PMML.Definition&targets=1&productionName=@productionId}";

Method GetModelInstance(pModelName As %String = "", Output pModel As %DeepSee.PMML.Model.AbstractModel) As %Status [ Private ]
{
	quit $classmethod(..PMMLClassName, "%GetModelInstance", $g(pModelName), .pModel)
}

/// Overrides the default setter to ensure model cache is cleared upon registering a new PMML class
Method PMMLClassNameSet(pClassName As %String) As %Status [ Internal, ServerOnly = 1 ]
{
	set i%PMMLClassName = pClassName
	quit ..Reset()
}

Method OnMessage(pRequest As GenericRequest, pResponse As GenericResponse) As %Status
{
	set tSC = $$$OK
	try {
		set tKey = ""
		for {
			set tValue = pRequest.ModelData.GetNext(.tKey)
			quit:tKey=""
			set tData(tKey) = tValue
		}
		
		#dim tOutput as %DeepSee.PMML.ModelOutput
		set tSC = ..InvokeModel(pRequest.ModelName, .tData, .tOutput)
		quit:$$$ISERR(tSC)
		
		set pResponse = ##class(GenericResponse).%New()
		set pResponse.PredictedValue = tOutput.%GetFeatureValue()
		
		do tOutput.%GetFields(.tFields)
		set tKey = ""
		for {
			set tKey = $order(tFields(tKey),1,tFieldData)
			quit:tKey=""
			do pResponse.ModelOutput.SetAt(tOutput.%GetFeatureValue($lg(tFieldData,1), $lg(tFieldData,2)), tKey)
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
