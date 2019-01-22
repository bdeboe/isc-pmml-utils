Class Demo.PMMLProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.PMMLProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Sample production leveraging the PMML BusinessOperation</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Generic PMML BO" Category="" ClassName="PMML.Interop.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PMMLClassName">Demo.SampleModels.GolfModel</Setting>
  </Item>
  <Item Name="Dedicated GolfModelBO" Category="" ClassName="Demo.SampleModels.GolfModel.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Decision Process" Category="" ClassName="Demo.GolfDecisionProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
