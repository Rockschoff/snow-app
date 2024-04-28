-- ==========================================
-- This script runs when the app is installed 
-- ==========================================

-- Create Application Role and Schema
create application role if not exists app_instance_role;
create or alter versioned schema app_instance_schema;

-- Share data
create or replace view app_instance_schema.ENV_MONITORING as select * from shared_content_schema.ENV_MONITORING;
create or replace view app_instance_schema.EQUIPMENT_AUDIT as select * from shared_content_schema.EQUIPMENT_AUDIT;
create or replace view app_instance_schema.FSQ_MISSES as select * from shared_content_schema.FSQ_MISSES;
create or replace view app_instance_schema.INTERNAL_AUDIT as select * from shared_content_schema.INTERNAL_AUDIT;
create or replace view app_instance_schema.PC_CCP_DEVIATION as select * from shared_content_schema.PC_CCP_DEVIATION;
create or replace view app_instance_schema.SUPPLIED_MATERIAL_QUALITY as select * from shared_content_schema.SUPPLIED_MATERIAL_QUALITY;
create or replace view app_instance_schema.SANITATION as select * from shared_content_schema.SANITATION;
create or replace view app_instance_schema.SUPPLIER_PERFORMANCE as select * from shared_content_schema.SUPPLIER_PERFORMANCE;

-- Create Streamlit app
create or replace streamlit app_instance_schema.streamlit from '/libraries' main_file='streamlit.py';

-- Grant usage and permissions on objects
grant usage on schema app_instance_schema to application role app_instance_role;


grant SELECT on view app_instance_schema.ENV_MONITORING to application role app_instance_role;
grant SELECT on view app_instance_schema.EQUIPMENT_AUDIT to application role app_instance_role;
grant SELECT on view app_instance_schema.FSQ_MISSES to application role app_instance_role;
grant SELECT on view app_instance_schema.INTERNAL_AUDIT to application role app_instance_role;
grant SELECT on view app_instance_schema.PC_CCP_DEVIATION to application role app_instance_role;
grant SELECT on view app_instance_schema.SUPPLIED_MATERIAL_QUALITY to application role app_instance_role;
grant SELECT on view app_instance_schema.SANITATION to application role app_instance_role;
grant SELECT on view app_instance_schema.SUPPLIER_PERFORMANCE to application role app_instance_role;


grant usage on streamlit app_instance_schema.streamlit to application role app_instance_role;



-- snow object stage copy ./data/Environmental_Monitoring.csv @%ENV_MONITORING --database DEMO_APP_DB --schema ENV_MONITORING_SCHEMA

-- snow object stage copy ./data/Equipment_Audit.csv @%EQUIPMENT_AUDIT --database DEMO_APP_DB --schema EQUIPMENT_AUDIT_SCHEMA

-- snow object stage copy ./data/FSQ_Misses_Withdrawals.csv @%FSQ_MISSES --database DEMO_APP_DB --schema FSQ_MISSES_SCHEMA

-- snow object stage copy ./data/Internal_Audit.csv @%INTERNAL_AUDIT --database DEMO_APP_DB --schema INTERNAL_AUDIT_SCHEMA

-- snow object stage copy ./data/PC_CCP_Deviation.csv @%PC_CCP_DEVIATION --database DEMO_APP_DB --schema PC_CCP_DEVIATION_SCHEMA

-- snow object stage copy ./data/Quality_of_Supplied.csv @%SUPPLIED_MATERIAL_QUALITY --database DEMO_APP_DB --schema SUPPLIED_MATERIAL_QUALITY_SCHEMA

-- snow object stage copy ./data/Sanitation.csv @%SANITATION --database DEMO_APP_DB --schema SANITATION_SCHEMA

-- snow object stage copy ./data/Supplier_Performance.csv @%SUPPLIER_PERFORMANCE --database DEMO_APP_DB --schema SUPPLIER_PERFORMANCE_SCHEMA