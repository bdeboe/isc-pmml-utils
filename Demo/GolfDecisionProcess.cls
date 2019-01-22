/// Simple Business Process that invokes two PMML models predicting whether or not to go golfing based on weather input and then decides whether to stay home or not
Class Demo.GolfDecisionProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.WeatherRequest' response='Ens.StringResponse' height='2000' width='2000' >
<context>
<property name='decision1' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='decision2' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='finalDecision' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='650' >
<call name='Call GolfModel' target='Generic PMML BO' async='0' xpos='200' ypos='250' >
<annotation><![CDATA[Check first model]]></annotation>
<request type='PMML.Interop.GenericRequest' >
<assign property="callrequest.ModelName" value="&quot;golfing&quot;" action="set" />
<assign property="callrequest.ModelData" value="request.temperature" action="set" key="&quot;temperature&quot;" />
<assign property="callrequest.ModelData" value="request.outlook" action="set" key="&quot;outlook&quot;" />
<assign property="callrequest.ModelData" value="request.humidity" action="set" key="&quot;humidity&quot;" />
<assign property="callrequest.ModelData" value="request.windy" action="set" key="&quot;windy&quot;" />
</request>
<response type='PMML.Interop.GenericResponse' >
<assign property="context.decision1" value="callresponse.PredictedValue" action="set" />
</response>
</call>
<call name='Call GolfModel2' target='Dedicated GolfModelBO' async='0' xpos='200' ypos='350' >
<annotation><![CDATA[Check second model, just to be sure we don't get soaked!]]></annotation>
<request type='Demo.SampleModels.GolfModel.Msg.golfing2Req' >
<assign property="callrequest.Input.outlook" value="request.outlook" action="set" />
<assign property="callrequest.Input.temperature" value="request.temperature" action="set" />
<assign property="callrequest.Input.humidity" value="request.humidity" action="set" />
</request>
<response type='Demo.SampleModels.GolfModel.Msg.golfing2Resp' >
<assign property="context.decision2" value="callresponse.Output.whatIdo" action="set" />
</response>
</call>
<rule name='Decision' rule='Demo.GolfDecisionRule'  resultLocation='context.finalDecision' ruleContext='context' xpos='200' ypos='450' >
<annotation><![CDATA[Now decide what we'll do]]></annotation>
</rule>
<assign name="Assign final result" property="response.StringValue" value="context.finalDecision" action="set" xpos='200' ypos='550' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
