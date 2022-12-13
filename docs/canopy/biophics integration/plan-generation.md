# Plan Generation

This is the process of transforming a Case Details event into a Focus Investigation plan.
A Case Details event is generated from a Biophics index case. _[See process here](index-case-generation.md)_

The Plan Generation Processor Group in NiFi is where this happens.

- The process starts by pulling new Case Details events from OpenSRP, using our [ETL state machine PG](ingestion-from-opensrp.md) to track state
- When records are retrieved we start by checking that they have all the required fields populated
- Next a query is run against the dbo.auto_generated_plans table to confirm that no plan has been generated for the specified event. If a plan already exists with the case details eventID, the flowfile is rerouted and left to 'hang' otherwise the process continues
- We then confirm that a matching OpenSRP jurisdiction exists for the Biophics opearational area id provided in the index case
- Next step is to pick a plan template. There are 3 options available

| Pseudocode Logic                                                                                                                     | Template |
| ------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| If (focus_status == A1 OR focus_status == A2)                                                                                        | 1        |
| If (focus_status == B1 )                                                                                                             | 2        |
| If ((focus_status == B1 OR focus_status == B2) AND (case_classification == local) AND (historical_interventions == IRS))             | 1        |
| If ((focus_status == B1 OR focus_status == B2) AND (case_classification == local) AND (historical_interventions == Blood Screening)) | 3        |

- [More info on focus_status](focus-area-classification.md)
- [More info on case_classification](case-classification.md)

### Plan Templates

Below are the actions that build the 3 different plan templates/types

| Template | Actions                                                                                                                                                            |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1        | Index Case Confirmation, Family Registration, Blood Screening, Bednet Distribution, Larval Dipping, Mosquito Collection, Behaviour Change Communication (BCC)      |
| 2        | Index Case Confirmation, Family Registration, Blood Screening, Behaviour Change Communication (BCC)                                                                |
| 3        | Index Case Confirmation, Family Registration, Blood Screening, Larval Dipping, Mosquito Collection, Indoor Residual Spraying, Behaviour Change Communication (BCC) |

Once the plan template is selected, the plan payload is generated and posted to the OpenSRP endpoint. Finally we update the dbo.auto_generated_plans table with the plan details

---

### Places to check in case a plan has not been generated

- Are all the required fields available in the event?
- Are there any 'stuck' FlowFiles in the PG?
- Does the focus_status and case_classification combination match up to a template?
- Does the plan exist in the dbo.auto_generated_plans table?
