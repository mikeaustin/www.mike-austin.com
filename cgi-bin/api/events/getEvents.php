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

	$result = mysql_query('
	 SELECT `id`, `what`, `where`, `when`, `location`
	 FROM `events`
	 WHERE 1
	 ORDER BY `when` DESC
	');

	$i = 0;
	echo "[\n";
	while ($row = mysql_fetch_assoc($result))
	{
		if ($i++ != 0) echo ",\n";
		echo '    { id: "' . $row['id'] . '", ' .
			 'what: ' . json_encode(($row['what'])) . ', ' .
			 'where: ' . json_encode(htmlspecialchars($row['where'])) . ', ' .
			 'when: new Date(' . json_encode(str_replace('-', '/', $row['when'])) . '), ' .
			 'location: ' . json_encode(htmlspecialchars($row['location'])) . ' }';
	}
	echo "\n]";
?>
