# Setup

In order to setup symmetricDS for Biophics

1. Download the SymmetricDS standalone ZIP file from [here](https://sourceforge.net/projects/symmetricds/files/)
2. Unzip the file and place it in `/opt/symmetricDS` in the server (nifi server for the case of Biophics)
3. Copy the `warehouse-000.properties` and the `target-001.properties` files and place them in `/opt/symmetricDS/engines` in the server
4. Create the SymmetricDS tables using `/bin/symadmin --engine warehouse-000 create-sym-tables`
5. Load the SymmetricDS configurations into the root node database using `/bin/dimport --engine warehouse-000 insert_configs.sql`
6. `bin/sym_service install`
7. `bin/sym_service start` to start service (and `bin/sym_service stop` to stop)
8. `bin/symadmin --engine warehouse-000 reload-node 001` to start initial load
