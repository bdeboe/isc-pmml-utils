/// Simple and somewhat sheepish rule that decides to stay home if either model decided to do so.
Class Demo.GolfDecisionRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Demo.GolfDecisionProcess.Context" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="(decision1=&quot;no play&quot;)||(decision2=&quot;no play&quot;)">
<return>"no play"</return>
</when>
<when condition="(decision1=&quot;may play&quot;)||(decision2=&quot;may play&quot;)">
<return>"may play"</return>
</when>
</rule>
<return>"will play"</return>
</ruleSet>
</ruleDefinition>
}

}
