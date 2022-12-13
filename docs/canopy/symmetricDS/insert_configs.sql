------------------------------------------------------------------------------
-- Clear and load SymmetricDS Configuration
------------------------------------------------------------------------------

delete from sym_trigger_router;
delete from sym_trigger;
delete from sym_router;
delete from sym_channel;
delete from sym_node_group_link;
delete from sym_node_group;
delete from sym_node_host;
delete from sym_node_identity;
delete from sym_node_security;
delete from sym_node;

------------------------------------------------------------------------------
-- Channels
------------------------------------------------------------------------------

-- Channel "events"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('events', 1, 100000, 1, 'Events data');

-- Channel "tasks"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('tasks', 1, 100000, 1, 'Tasks data');

-- Channel "plans"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('plans', 1, 100000, 1, 'Plans data');

-- Channel "structures"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('structures', 1, 100000, 1, 'Structures data');

-- Channel "jurisdictions"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('jurisdictions', 1, 100000, 1, 'jurisdictions data');

-- Channel "clients"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('clients', 1, 100000, 1, 'Clients data');

-- Channel "organizations"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('organizations', 1, 100000, 1, 'Organizations data');

-- Channel "providers"
insert into sym_channel
    (channel_id, processing_order, max_batch_size, enabled, description)
values('providers', 1, 100000, 1, 'Providers data');


------------------------------------------------------------------------------
-- Node Groups
------------------------------------------------------------------------------

insert into sym_node_group
    (node_group_id, description)
values
    ('warehouse', 'The Ona data warehouse: postgres db');
insert into sym_node_group
    (node_group_id, description)
values
    ('target', 'The Biophics server: sqlserver db');

------------------------------------------------------------------------------
-- Node Group Links
------------------------------------------------------------------------------

-- Warehouse sends changes to target when target pulls from warehouse
insert into sym_node_group_link
    (source_node_group_id, target_node_group_id, data_event_action)
values
    ('warehouse', 'target', 'W');

------------------------------------------------------------------------------
-- Triggers
------------------------------------------------------------------------------

-- Triggers for tables
insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('events', 'raw_events', 'events', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('tasks', 'raw_tasks', 'tasks', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('plans', 'raw_plans', 'plans', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('structures', 'raw_structures', 'structures', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('jurisdictions', 'raw_jurisdictions', 'jurisdictions', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('clients', 'raw_clients', 'clients', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('organizations', 'raw_organizations', 'organizations', current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('providers', 'raw_providers', 'providers', current_timestamp, current_timestamp);


-- Triggers with capture disabled, so they are used for initial load only
insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('events_warehouse', 'raw_events', 'events', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('tasks_warehouse', 'raw_tasks', 'tasks', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('plans_warehouse', 'raw_plans', 'plans', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('structures_warehouse', 'raw_structures', 'structures', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('jurisdictions_warehouse', 'raw_jurisdictions', 'jurisdictions', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('clients_warehouse', 'raw_clients', 'clients', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('organizations_warehouse', 'raw_organizations', 'organizations', 0, 0, 0, current_timestamp, current_timestamp);

insert into sym_trigger
    (trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('providers_warehouse', 'raw_providers', 'providers', 0, 0, 0, current_timestamp, current_timestamp);

------------------------------------------------------------------------------
-- Routers
------------------------------------------------------------------------------

-- Default router sends all data from warehouse to target
insert into sym_router
    (router_id,source_node_group_id,target_node_group_id,router_type,create_time,last_update_time)
values('warehouse_to_target', 'warehouse', 'target', 'default', current_timestamp, current_timestamp);


------------------------------------------------------------------------------
-- Trigger Routers
------------------------------------------------------------------------------

-- Send all items to all targets
insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('events', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('tasks', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('plans', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('structures', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('jurisdictions', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('clients', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('organizations', 'warehouse_to_target', 100, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('providers', 'warehouse_to_target', 100, current_timestamp, current_timestamp);


-- Send all items to target during initial load
insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('events_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('tasks_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('plans_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('structures_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('jurisdictions_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('clients_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('organizations_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
    (trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('providers_warehouse', 'warehouse_to_target', 200, current_timestamp, current_timestamp);