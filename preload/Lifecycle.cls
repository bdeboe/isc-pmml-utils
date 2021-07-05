Class PMML.Lifecycle Extends %ZPM.PackageManager.Developer.Lifecycle.Module
{

Method %Activate(ByRef pParams) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ##super(.pParams)
		If $$$ISERR(tSC) {
			Quit
		}
		
		Set tRootDirectory = $Get(pParams("RootDirectory"))
		Set tVerbose = $Get(pParams("Verbose"),0)
		Set tSeparator = $s($$$isWINDOWS:"\",1:"/")
		Write:tVerbose !,"Loading raw PMML file ..."
		Set tSC = ##class(%DeepSee.PMML.Utils).CreateFromFile(tRootDirectory_"src"_tSeparator_"pmml"_tSeparator_"MyGolfModel.pmml","Demo.SampleModels.GolfModel", 1, 1, tVerbose)
		$$$ThrowOnError(tSC)
		Write:tVerbose !,"Importing demo code..."
		Set tSC = $SYSTEM.OBJ.LoadDir(tRootDirectory_"src"_tSeparator_"cls"_tSeparator_"Demo", "k -c"_$s(tVerbose:"d",1:"-d"),, 1)
		$$$ThrowOnError(tSC)
		Write:tVerbose !,"Running Interop generator..."
		Set tSC = ##class(PMML.Interop.Utils).GenerateOperation("Demo.SampleModels.GolfModel")
		$$$ThrowOnError(tSC)
		Write:tVerbose !,"Compiling..."
		Set tSC = $SYSTEM.OBJ.CompilePackage("Demo", "ck"_$s(tVerbose:"d",1:"-d"))
		$$$ThrowOnError(tSC)
		Write:tVerbose !,"Done."
	} Catch e {
		Set tSC = e.AsStatus()
	}
	Quit tSC
}

}
