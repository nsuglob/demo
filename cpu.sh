#!/bin/bash
while :;
do
  sleep 1
  cat > /var/www/html/cpu.html << EOF
	<html>
		<head>
			<meta http-equiv="refresh" content="1">
		</head>
		<body>
			<pre>$(mpstat)></pre>
		</body>
	</html>
EOF
done