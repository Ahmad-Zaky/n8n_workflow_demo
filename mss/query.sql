-- Test query
-- SELECT TOP 1 param_request, param_response FROM cjrequest

SELECT
  startzeit_ist,
  param_request,
  param_response
FROM dbo.cjrequest
WHERE
  restcall_url = :restcall_url
  AND request_status != 200
  AND startzeit_ist >= :date_from
  AND startzeit_ist <  :date_to
ORDER BY startzeit_ist DESC
