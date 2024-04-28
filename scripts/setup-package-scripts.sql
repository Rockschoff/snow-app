-- ################################################################
-- Create SHARED_CONTENT_SCHEMA to share in the application package
-- ################################################################
USE {{ package_name }};
create schema if not exists shared_content_schema;

use schema shared_content_schema;
create or replace view ENV_MONITORING as select * from DEMO_APP_DB.ENV_MONITORING_SCHEMA.ENV_MONITORING;
create or replace view EQUIPMENT_AUDIT as select * from DEMO_APP_DB.EQUIPMENT_AUDIT_SCHEMA.EQUIPMENT_AUDIT;
create or replace view FSQ_MISSES as select * from DEMO_APP_DB.FSQ_MISSES_SCHEMA.FSQ_MISSES;
create or replace view INTERNAL_AUDIT as select * from DEMO_APP_DB.INTERNAL_AUDIT_SCHEMA.INTERNAL_AUDIT;
create or replace view PC_CCP_DEVIATION as select * from DEMO_APP_DB.PC_CCP_DEVIATION_SCHEMA.PC_CCP_DEVIATION;
create or replace view SUPPLIED_MATERIAL_QUALITY as select * from DEMO_APP_DB.SUPPLIED_MATERIAL_QUALITY_SCHEMA.SUPPLIED_MATERIAL_QUALITY;
create or replace view SANITATION as select * from DEMO_APP_DB.SANITATION_SCHEMA.SANITATION;
create or replace view SUPPLIER_PERFORMANCE as select * from DEMO_APP_DB.SUPPLIER_PERFORMANCE_SCHEMA.SUPPLIER_PERFORMANCE;


grant usage on schema shared_content_schema to share in application package {{ package_name }};
grant reference_usage on database DEMO_APP_DB to share in application package {{ package_name }};
grant select on view ENV_MONITORING to share in application package {{ package_name }};
grant select on view EQUIPMENT_AUDIT to share in application package {{ package_name }};
grant select on view FSQ_MISSES to share in application package {{ package_name }};
grant select on view INTERNAL_AUDIT to share in application package {{ package_name }};
grant select on view PC_CCP_DEVIATION to share in application package {{ package_name }};
grant select on view SUPPLIED_MATERIAL_QUALITY to share in application package {{ package_name }};
grant select on view SANITATION to share in application package {{ package_name }};
grant select on view SUPPLIER_PERFORMANCE to share in application package {{ package_name }};