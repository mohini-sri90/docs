Drools Rules Execution Operator
=====================

### Introduction
This operator processes incoming tuples against set of rules to identify meaningful events which can be acted upon quickly. Drools rules execution operator uses apache licensed [drools](https://www.drools.org/) librabry to do rules processing.


### Why is it needed ?
Many business domains need to process data to identiy meaningful events or patterns to take certian actions. Those businesses will need this operator.

### DroolsOperator
Drools operator does static rules evaluation on incoming tuples. The rules are customizable. It's advisable to write rules as per your business requirements and configure it to operator. Please refer Configuration section to know how to configure rules for operator.

#### Ports
factsInput  &lt;Object&gt;: Receives tuples from upstream operators.

factsOutput &lt;Object&gt;: Emits processed facts on factsOutput port.

ruleCountOutput &lt;Map<String, MutableInt>&gt;: Map of rules and number of times each rule was fired in a window.

firedRuleAndTransactionOutput &lt;KeyValPair<String, Set<Object>>&gt;: Map of rules and list of tuples wich triggered the rule in window.

factAndFiredRulesOutput &lt;Map<Object, Set<String>>&gt;: Map of tuple and rules fired by the tuple.

### Pre-requisites


#### Configuration Parameters
<table>
<col width="25%" />
<col width="75%" />
<tbody>
<tr class="odd">
<td align="left"><p>Parameter</p></td>
<td align="left"><p>Description</p></td>
</tr>
<tr class="even">
<td align="left"><p>rulesDir</p></td>
<td align="left"><p>HDFS path of rule files/direcotory containing files. Supported format are drl and decision tables (xls). <br/>If rulesDir is not configured default packaged rules are loaded by operator.</p></td>
</tr>
</tbody>
</table>

### Partitioning
Multiple instances of operator
