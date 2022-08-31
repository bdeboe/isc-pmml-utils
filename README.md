![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=blue&label=ZPM%20version&version&prefix=v&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbdeboe%2Fisc-pmml-utils%2Fmaster%2Fmodule.xml)


# PMML Business Operation

This repository offers a generic Business Operation for leveraging predictive models expressed in PMML in your Interoperability productions. See below for a description of the utility code or skip through to [the sample](#the-sample). 

## PMML 101

If you're not familiar with PMML, you can read more about it [here](http://dmg.org/pmml/v4-3/GeneralStructure.html) and on how InterSystems IRIS supports it [here](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=APMML). 

If you already have a PMML model in some `MyModel.pmml` file, here's the TL;DR:

```ObjectScript
USER> do ##class(%DeepSee.PMML.Utils).CreateFromFile("/path/to/MyModel.pmml","Demo.MyModel")
...

USER> set data("Feature1") = 123, data("Feature2") = "abc", ...

USER> do ##class(Demo.MyModel).%GetModelInstance(.model)

USER> do model.%ExecuteModel(.data, .output)

USER> zwrite output
...
```


## The Business Operation

Running PMML models natively in an InterSystems IRIS Business Process has of course always been the goal of our PMML support, but somehow never made it into the kit because there were a few dependencies and choices that needed addressing and answering. Anyhow, thanks to some pushing and code snippets from @amirsamary, we finally got it wrapped in a GitHub repo for your enjoyment, review and suggestions.

The utility classes in this repo offer two ways to invoke PMML models from a BO.
- [PMML.Interop.AbstractBusinessOperation](./src/cls/PMML/Interop/AbstractBusinessOperation.cls) is a utility superclass avoiding a small amount of code duplication. (it wasn't broken, but we still decided to fix it! :nerd_face:)
- [PMML.Interop.BusinessOperation](./src/cls/PMML/Interop/BusinessOperation.cls) is our generic Business Operation for running PMML models, to be used with [PMML.Interop.GenericRequest](./src/cls/PMML/Interop/GenericRequest.cls) and [PMML.Interop.GenericResponse](./src/cls/PMML/Interop/GenericResponse.cls)
- [PMML.Interop.Utils](./src/cls/PMML/Interop/Utils.cls) includes the method to generate dedicated Business Operation implementations and request / response objects for your PMML models.
Note also that all classes have self-documenting class reference.

### Using a generic Business Operation

The generic BO class `PMML.Interop.BusinessOperation` is just that: a generic BO. If you include it in your production, you *have* to supply a value for its `PMMLClassName` setting, which should refer to the classname of a valid PMML definition class (inherit from `%DeepSee.PMML.Definition`).

The `PMML.Interop.GenericRequest` object allows specifying the name of the model to use (in case your PMML definition has more than one) and has a generic array in which you can dump all the model input values. This means that in the Assign steps, you'll have to supply a key that corresponds to the model input name, which is slightly less convenient for large or complex models. The `PMML.Interop.GenericResponse` object has the main predicted value straight as a property, but also includes an array holding all the other output fields produced by the model, upon succesful completion of the model code.

### Generating dedicated Business Operations

If you're not entirely limited to SMP access to your instance (in which case the above is your only option right now), you can use the `PMML.Interop.Utils` class to generate a dedicated BO and corresponding request and response message classes for your PMML models. While an extra step, having those request and response messages refer to your input and output field names directly is a great help when using the request builder. To generate these classes, simply call
   ```ObjectScript
   do ##class(PMML.Interop.Utils).GenerateOperation("Your.PMML.ClassName")
   ```
This will create the corresponding operation and message classes in the same generated package as the other PMML artefacts (overwriting existing entries).

:warning: Note that the BO generation mechanism requires a few serialization enhancements to the core PMML support in IRIS that are only packaged with IRIS 2019.1. If you want to work with an earlier version, please stick to the generic `PMML.Interop.BusinessOperation` class.


## The Sample

This repo includes a full example production showcasing how you can invoke both the generic and a generated BO for PMML models. It leverages a simple demo PMML file gratefully borrowed from dmg.org, the site hosting the PMML specification. The PMML file contains two tree models predicting whether it's a good idea to go golfing based on simple weather inputs. 

The sample code included in the Demo package consists of the following classes:
- [`MyGolfModel.pmml`](./src/pmml/MyGolfModel.pmml) is the raw PMML model definition containing two dummy decision trees. Note that the corresponding `%DeepSee.PMML.Definition` class is, nor the artefacts generated by [PMML.Interop.Utils](./src/cls/PMML/Interop/Utils.cls) are included on the repo. See [below](#using-the-sample) for instructions on how to generate those.
- [Demo.PMMLProduction](./src/cls/Demo/PMMLProduction.cls) is a simple Production listing the two BOs (generic and generated), as well as a basic Business Process invoking them both and deciding on the output. 
- [Demo.GolfDecisionProcess](./src/cls/Demo/GolfDecisionProcess.cls) is a Business Process invoking the two models and then calling on a Business Rule to make a final decision. This combining of different models' results can also be achieved _within_ PMML using [composite models](http://dmg.org/pmml/v4-3/MultipleModels.html), but that's pretty hardcore. In this sample we're doing it on the BPL side to show how you'd do it if you got these models from two different sources and cannot or don't want to fiddle with PMML.
- [Demo.GolfDecisionRule](./src/cls/Demo/GolfDecisionRule.cls) is a simple Business Rule invoked by the BPL.
- [Demo.WeatherRequest](./src/cls/Demo/WeatherRequest.cls) is a simple Ens.Request class capturing "current weather". This class is mostly there for your input convenience when testing the production / BPL.

### Using the sample

To install and use the sample, follow these steps:

1. Import and compile all this repo's classes into an Interoparability-enabled namespace. 
   Don't bother about the compile errors you might see from the BPL or Production class, as they refer to classes we're about to generate.

   Alternatively, use the [ZPM](https://github.com/intersystems-community/zpm) installation:

   ```ObjectScript
   INTEROP> zpm
   zpm: INTEROP>load /path/to/isc-pmml-utils
 
   [pmml-utils]    Reload START
   [pmml-utils]    Reload SUCCESS
   [pmml-utils]    Module object refreshed.
   [pmml-utils]    Validate START
   [pmml-utils]    Validate SUCCESS
   ...
   ```

2. We first need to import the raw `MyGolfModel.pmml` file and create a PMML definition _class_ in IRIS. This is taken care of if you chose to install through ZPM.
   ```ObjectScript
   w ##class(%DeepSee.PMML.Utils).CreateFromFile("/path/to/src/pmml/MyGolfModel.pmml", "Demo.SampleModels.GolfModel")
   ```

2. We now want to generate a dedicated BO for our PMML model, as used in the Production. This is also taken care of if you chose to install through ZPM. Please mind the class name argument or change the corresponding references in the production correspondingly.
   ```ObjectScript
   do ##class(PMML.Interop.Utils).GenerateOperation("Demo.SampleModels.GolfModel")
   ```

3. We're done setting up! Now it's just about testing our production:
    1. In the SMP, ensure you're in the right namespace and go to Interoperability > Configure > Production
    2. Open Demo > PMMLProduction
    3. Start your production. It should be test-enabled already.
    4. Now click the "Decision Process", select the "Actions" tab and hit the "Test" button.
    5. You can now supply values for our `Demo.WeatherRequest` object, invoke the testing service and admire the simple yet clear logging through the Visual Trace capability.
   
   
Don't hesitate to open issues or shoot me an email if you run into trouble.
