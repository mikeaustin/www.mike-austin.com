<?php
	ini_set('error_reporting', E_ALL);
	header('Content-type: text/plain; charset=utf-8');

	$dbhost = 'mike-aus.ipowermysql.com';
	$dbuser = 'mike_ekim';
	$dbpass = '128dxxxx';
	$dbname = 'events';
	
	$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die ('Error connecting to mysql');
	mysql_select_db($dbname);
	
	mysql_query('SET NAMES "utf8"');
	$result = mysql_query('SELECT * FROM events WHERE 1'); //id = ' . mysql_real_escape_string($_GET['event']));

	$i = 0;
	echo "[\n";
	while ($row = mysql_fetch_assoc($result))
	{
		if ($i++ != 0) echo ",\n";
		echo '    { id: "' . $row['id'] . '", ' .
			 'what: ' . json_encode(htmlspecialchars($row['what'])) . ', ' .
			 'where: ' . json_encode(htmlspecialchars($row['where'])) . ', ' .
			 'when: ' . json_encode(htmlspecialchars($row['when'])) . ', ' .
			 'location: ' . json_encode(htmlspecialchars($row['location'])) . ', ' .
			 //'details: "' . json_encode(nl2br(htmlspecialchars($row['details']))) . '" }'; may want to put in textarea
			 'details: ' . json_encode(htmlspecialchars($row['details'])) . ' }';
			 //'details: "' . str_replace("\r\n", '\r\n', htmlspecialchars($row['details'])) . '" }';
	}
	echo "\n]";
?>
