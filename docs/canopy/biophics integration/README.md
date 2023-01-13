# Reveal Th - Biophics Integration

## Introduction

Reveal has two components, the web user interface, which allows viewing and reviewing of focus investigations and the planning of future investigations, and the mobile client, which is mainly used by health workers to collect data for the investigations. The creation of a new focus investigation (plan) is triggered by a new malaria case found in one of the focus areas. The classification of the focus area, previous interventions in the area, the case classification, and other information collected when the case is first reported and during the case investigation are some of the things that determine which interventions are planned in response to the case.

The Biophics team together with the Bureau of Vector Borne Disease (BVBD) in Thailand work together to collect information about cases found in different focus areas.

The goal of this integration project is to create a link between Reveal and the Biophics system. Which will allow transfer of case information from the Biophics system to Reveal so as to trigger the creation of investigations, and at the same time, the transfer of data back to the Biophics system about the interventions.

## Summary

- Biophics integration is mainly creating a link between Reveal and the Biophics system
- We need to move case information from the Biophics system into Reveal. _See [index case generation](index-case-generation.md) for more info_
- Biophics would like to track the interventions as they occur, so we need to send all the data collected by the app back to the biophics system. We use SymmetricDS for this, _see [symmetricDS](../symmetricDS/README.md) for more info_
