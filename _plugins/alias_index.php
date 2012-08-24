<?php
if (!headers_sent()) {
  header("HTTP/1.1 301 Moved Permanently");
  header("Location: #{destination_path}");
}
?>
<!DOCTYPE html>
<html>
<head>
<link rel="canonical" href="#{destination_path}"/>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="0;url=#{destination_path}" />
</head>
</html>