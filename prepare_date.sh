snow sql -q "CREATE OR REPLACE WAREHOUSE DEMO_APP_WH WAREHOUSE_SIZE = SMALL INITIALLY_SUSPENDED = TRUE;

-- this database is used to store our data
CREATE OR REPLACE DATABASE DEMO_APP_DB;
USE DATABASE DEMO_APP_DB;

CREATE OR REPLACE SCHEMA ENV_MONITORING_SCHEMA;
USE SCHEMA ENV_MONITORING_SCHEMA;

CREATE OR REPLACE TABLE ENV_MONITORING (
    DATE TIMESTAMP,
    MONITORING_VALUE FLOAT 
);

CREATE OR REPLACE SCHEMA EQUIPMENT_AUDIT_SCHEMA;
USE SCHEMA EQUIPMENT_AUDIT_SCHEMA;

CREATE OR REPLACE TABLE EQUIPMENT_AUDIT (
    DATE TIMESTAMP,
    AUDIT_RESULT VARCHAR(20)
);

CREATE OR REPLACE SCHEMA FSQ_MISSES_SCHEMA;
USE SCHEMA FSQ_MISSES_SCHEMA;

CREATE OR REPLACE TABLE FSQ_MISSES (
    DATE TIMESTAMP,
    MISSES INT,
    WITHDRAWALS INT,
    RECALLS INT
);

CREATE OR REPLACE SCHEMA INTERNAL_AUDIT_SCHEMA;
USE SCHEMA INTERNAL_AUDIT_SCHEMA;

CREATE OR REPLACE TABLE INTERNAL_AUDIT (
    DATE TIMESTAMP,
    AUDIT_RESULT VARCHAR(20),
    COMMENT VARCHAR(30)
);

CREATE OR REPLACE SCHEMA PC_CCP_DEVIATION_SCHEMA;
USE SCHEMA PC_CCP_DEVIATION_SCHEMA;

CREATE OR REPLACE TABLE PC_CCP_DEVIATION (
    DATE TIMESTAMP,
    DEVIATION_REPORTED BOOLEAN
);

CREATE OR REPLACE SCHEMA SUPPLIED_MATERIAL_QUALITY_SCHEMA;
USE SCHEMA SUPPLIED_MATERIAL_QUALITY_SCHEMA;

CREATE OR REPLACE TABLE SUPPLIED_MATERIAL_QUALITY (
    DATE TIMESTAMP,
    NON_CONFORMITY BOOLEAN,
    HOLDS BOOLEAN,
    WASTE BOOLEAN,
    COA VARCHAR(30)
);

CREATE OR REPLACE SCHEMA SANITATION_SCHEMA;
USE SCHEMA SANITATION_SCHEMA;

CREATE OR REPLACE TABLE SANITATION (
    DATE TIMESTAMP,
    SANITATION_SCORE INT
);

CREATE OR REPLACE SCHEMA SUPPLIER_PERFORMANCE_SCHEMA;
USE SCHEMA SUPPLIER_PERFORMANCE_SCHEMA;

CREATE OR REPLACE TABLE SUPPLIER_PERFORMANCE (
    DATE TIMESTAMP,
    AUDIT_RESULTS VARCHAR(30)
);"


#staging the csv files

snow stage copy ./data/Environmental_Monitoring.csv @%ENV_MONITORING --database DEMO_APP_DB --schema ENV_MONITORING_SCHEMA

snow stage copy ./data/Equipment_Audit.csv @%EQUIPMENT_AUDIT --database DEMO_APP_DB --schema EQUIPMENT_AUDIT_SCHEMA

snow stage copy ./data/FSQ_Misses_Withdrawals.csv @%FSQ_MISSES --database DEMO_APP_DB --schema FSQ_MISSES_SCHEMA

snow stage copy ./data/Internal_Audit.csv @%INTERNAL_AUDIT --database DEMO_APP_DB --schema INTERNAL_AUDIT_SCHEMA

snow stage copy ./data/PC_CCP_Deviation.csv @%PC_CCP_DEVIATION --database DEMO_APP_DB --schema PC_CCP_DEVIATION_SCHEMA

snow stage copy ./data/Quality_of_Supplied.csv @%SUPPLIED_MATERIAL_QUALITY --database DEMO_APP_DB --schema SUPPLIED_MATERIAL_QUALITY_SCHEMA

snow stage copy ./data/Sanitation.csv @%SANITATION --database DEMO_APP_DB --schema SANITATION_SCHEMA

snow stage copy ./data/Supplier_Performance.csv @%SUPPLIER_PERFORMANCE --database DEMO_APP_DB --schema SUPPLIER_PERFORMANCE_SCHEMA

#load data from table stages into tables
snow sql -q "USE WAREHOUSE DEMO_APP_WH;
-- this database is used to store our data
USE DATABASE DEMO_APP_DB;

USE SCHEMA ENV_MONITORING_SCHEMA;

COPY INTO ENV_MONITORING
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA EQUIPMENT_AUDIT_SCHEMA;

COPY INTO EQUIPMENT_AUDIT
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA FSQ_MISSES_SCHEMA;

COPY INTO FSQ_MISSES
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA INTERNAL_AUDIT_SCHEMA;

COPY INTO INTERNAL_AUDIT
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA PC_CCP_DEVIATION_SCHEMA;

COPY INTO PC_CCP_DEVIATION
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA SUPPLIED_MATERIAL_QUALITY_SCHEMA;

COPY INTO SUPPLIED_MATERIAL_QUALITY
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA SANITATION_SCHEMA;

COPY INTO SANITATION
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');

USE SCHEMA SUPPLIER_PERFORMANCE_SCHEMA;

COPY INTO SUPPLIER_PERFORMANCE
FILE_FORMAT = (TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');


"