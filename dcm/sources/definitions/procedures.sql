DEFINE PROCEDURE SDLC_DEMO{{env_suffix}}.RAW.INSERT_DATA(
    P_ID NUMBER,
    P_NAME VARCHAR,
    P_CATEGORY VARCHAR,
    P_AMOUNT NUMBER(10,2),
    P_CREATED_AT TIMESTAMP_NTZ DEFAULT NULL
)
RETURNS NUMBER
LANGUAGE SQL
COMMENT = 'Inserts one row into RAW.DATA; returns rows inserted. CREATED_AT defaults to now.'
AS
$$
BEGIN
    INSERT INTO SDLC_DEMO{{env_suffix}}.RAW.DATA (ID, NAME, CATEGORY, AMOUNT, CREATED_AT)
    VALUES (:P_ID, :P_NAME, :P_CATEGORY, :P_AMOUNT, COALESCE(:P_CREATED_AT, CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    RETURN SQLROWCOUNT;
END;
$$;

DEFINE PROCEDURE SDLC_DEMO{{env_suffix}}.RAW.TEST_INSERT_DATA()
RETURNS VARCHAR
LANGUAGE SQL
COMMENT = 'Asserts INSERT_DATA adds exactly one row, then removes the test row. Raises on failure.'
AS
$$
DECLARE
    rows_before NUMBER;
    rows_after NUMBER;
    rows_reported NUMBER;
    insert_check_failed EXCEPTION (-20001, 'TEST_INSERT_DATA failed: row count did not increase by exactly 1');
BEGIN
    SELECT COUNT(*) INTO :rows_before FROM SDLC_DEMO{{env_suffix}}.RAW.DATA;

    CALL SDLC_DEMO{{env_suffix}}.RAW.INSERT_DATA(-1, '__TEST__', '__TEST__', 0) INTO :rows_reported;

    SELECT COUNT(*) INTO :rows_after FROM SDLC_DEMO{{env_suffix}}.RAW.DATA;

    DELETE FROM SDLC_DEMO{{env_suffix}}.RAW.DATA WHERE ID = -1 AND NAME = '__TEST__';

    IF (rows_after - rows_before != 1 OR rows_reported != 1) THEN
        RAISE insert_check_failed;
    END IF;

    RETURN 'PASS: ' || rows_before || ' -> ' || rows_after || ' rows; INSERT_DATA reported ' || rows_reported;
END;
$$;
