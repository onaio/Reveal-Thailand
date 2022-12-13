# SymmetricDS

SymmetricDS is open source software for database and file synchronization, with support for multi-master replication, filtered synchronization, and transformation. It uses web and database technologies to replicate change data as a scheduled or near real-time operation, and it includes an initial load feature for full data loads. The software was designed to scale for a large number of nodes, work across low-bandwidth connections, and withstand periods of network outage.

- Quick start tutorial can be found [here](https://www.symmetricds.org/doc/3.11/html/tutorials.html)

- User guide can be found [here](https://www.symmetricds.org/doc/3.11/html/user-guide.html)

## Biophics

For this project SymmetricDS is used for database replication. We have created tables in the canopy datawarehouse, which need to be replicated in the Biophics sql server database. The tables being replicated are:

- raw_events
- raw_tasks
- raw_clients
- raw_plans
- raw_jurisdictions
- raw_structures
- raw_organizations
- raw_providers
