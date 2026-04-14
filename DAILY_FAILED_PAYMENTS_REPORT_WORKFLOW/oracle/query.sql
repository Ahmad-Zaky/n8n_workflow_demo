-- Test Query
-- SELECT param_request, param_response FROM cjrequest WHERE ROWNUM = 1

SELECT
    param_request,
    param_response
FROM cjrequest
WHERE
    restcall_url = :restcall_url
  AND request_status != 200
  AND startzeit_ist >= TO_DATE(:date_from, 'YYYYMMDD')
  AND startzeit_ist <  TO_DATE(:date_to,   'YYYYMMDD')
ORDER BY startzeit_ist DESC
