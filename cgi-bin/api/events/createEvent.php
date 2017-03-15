<?php
	ini_set('error_reporting', E_ALL);

	$dbhost = 'mike-aus.ipowermysql.com';
	$dbuser = 'mike_ekim';
	$dbpass = '128dxxxx';
	$dbname = 'events';
	
	$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die('Error connecting to mysql');
	mysql_select_db($dbname);
	
	$when = new DateTime($_POST['when']);
	echo $when->format('Y-m-d H:i:s');
	
	$query = "
	 INSERT INTO events (`what`, `where`, `when`, `location`, `details`)
	 VALUES(" .
	  "'" . mysql_real_escape_string($_POST['what']) . "', " .
	  "'" . mysql_real_escape_string($_POST['where']) . "', " .
	  "'" . mysql_real_escape_string($when->format('Y-m-d H:i:s')) . "', " .
	  "'" . mysql_real_escape_string($_POST['location']) . "', " .
	  "'" . mysql_real_escape_string($_POST['details']) . "')";
	
	mysql_query($query) or die(mysql_error());
?>
