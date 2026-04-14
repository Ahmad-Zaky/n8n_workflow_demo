-- SET PAGESIZE 50000
-- SET LINESIZE 32767
-- SET LONG 2000000
-- SET LONGCHUNKSIZE 2000000
-- SET FEEDBACK OFF
-- SET HEADING ON
-- SET MARKUP CSV ON DELIMITER , QUOTE ON

SELECT param_request, param_response FROM cjrequest WHERE ROWNUM = 1;

-- EXIT;

-- SELECT
--     param_request,
--     param_response
-- FROM cjrequest
-- WHERE
--     restcall_url = 'https://yourdomain.com/yourendpoint'
--   AND request_status = 200
--   AND startzeit_ist >= TO_DATE('20241125', 'YYYYMMDD')
--   AND startzeit_ist <  TO_DATE('20261127', 'YYYYMMDD')
-- ORDER BY startzeit_ist DESC;
