<?php
	ini_set('error_reporting', E_ALL);

	$dbhost = 'mike-aus.ipowermysql.com';
	$dbuser = 'mike_ekim';
	$dbpass = '128dxxxx';
	$dbname = 'events';
	
	$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die ('Error connecting to mysql');
	mysql_select_db($dbname);
	
	$result = mysql_query('SELECT * FROM events WHERE id = ' . mysql_real_escape_string($_GET['event']));

	$i = 0;
	echo "[\n";
	while ($row = mysql_fetch_assoc($result))
	{
		if ($i++ != 0) echo ",\n";
		echo '    { id: "' . $row['id'] . '", ' .
			 'what: "' . htmlspecialchars($row['what']) . '", ' .
			 'where: "' . htmlspecialchars($row['where']) . '", ' .
			 'when: "' . htmlspecialchars($row['when']) . '", ' .
			 'location: "' . htmlspecialchars($row['location']) . '", ' .
			 'details: "' . htmlspecialchars($row['details']) . '" }';
	}
	echo "\n]";
?>
