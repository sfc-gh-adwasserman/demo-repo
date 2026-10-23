DEFINE DATABASE SDLC_DEMO{{env_suffix}}
    COMMENT = 'SDLC demo database managed by DCM';

DEFINE SCHEMA SDLC_DEMO{{env_suffix}}.RAW
    COMMENT = 'Raw landing layer';

DEFINE WAREHOUSE SDLC_WH{{env_suffix}}
WITH
    WAREHOUSE_SIZE = '{{wh_size}}'
    GENERATION = '1'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'SDLC demo warehouse (Gen1)';
