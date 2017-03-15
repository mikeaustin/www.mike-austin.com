<html>

<head>
<style type="text/css">
  body, input, td { font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
  a, a:visited { color: #4060C0; text-decoration: none; }
  a:hover { text-decoration: underline; }
</style>
</head>

<body bgcolor="#FFFFFF" onLoad="document.form.Filter.focus()">

<?php

// open the connection
$conn = mysql_connect( "mike-aus.ipowermysql.com", "mike-aus_user", "user" );

// create database testdb
//$create_success = mysql_create_db( "testdb" );

mysql_select_db( "mike-aus_MUSIC", $conn );

if( !empty( $_GET[Name] ) ) {
  if( !is_numeric( $_GET[Age] ) ) die( "Age must be an int" );
  $name = $_GET[Name];
  $sql = "insert into TEST values ('$name', $_GET[Age])";
  $result = mysql_query( $sql, $conn ) or die( mysql_error() );
}

$group = 'Song';
$filter = '';
if( isset( $_GET[Group] ) ) { $group = $_GET[Group]; }
if( isset( $_GET[Filter] ) ) { $filter = $_GET[Filter]; }

echo '
<form name="form" action="" method="get">
  Filter: <input type="text" name="Filter"/ value="', $filter, '"> <input type="submit"/>
  <input type="hidden" name="Group"/ value="', $group, '">
</form>
';

$sql = "select * from MUSIC where Song like '%" . $filter . "%' or Artist like %', $filter, '% order by " . $group;
$sql = "select * from MUSIC
 where Song like '%$filter%' or
       Artist like '%$filter%' or
       Genre like '%$filter%'
       order by $group";

$result = mysql_query( $sql, $conn ) or die( mysql_error() );

function data_table( $data, $filter, $group, $headers, $fields ) {
  echo '<table style="table-layout: fixed" border="0" cellpadding="2" cellspacing="1">';

  // Table headers
  echo '<tr bgcolor="#F0F0F0">';
    foreach( $headers as $field ) {
      echo '<td>&nbsp;<a href="?Filter=', $filter, '&Group=', $field, '">', $field, '</a>&nbsp;</td>';
    }
    $columns = count( $headers );
  echo '</tr>';

  // Table rows
  while( $row = mysql_fetch_array( $data ) ) {
    if( $last != $row[$group] ) {
      echo '<tr bgcolor="#F0F0F0">';
      echo '<td colspan=' . $columns . '>&nbsp;', $group, ': ', $row[$group], '</td>';
      echo '</tr>';
    }
    echo '<tr>';
      foreach( $fields as $field ) {
        if( $field == $fields[0] ) {
          echo '<td>&nbsp;&nbsp;&nbsp;&nbsp;<a href="">', $row[$field], '</a>&nbsp;</td>';
        } else {
          echo '<td>&nbsp;', $row[$field], '&nbsp;</td>';
        }
      }
    echo '</tr>';
    $last = $row[$group];
  }

  echo '</table>';
}

data_table( $result, $filter, $group,
            array( 'Song', 'Artist', 'Year', 'Rating', 'Genre' ),
            array( Song, Artist, Year, Rating, Genre ) );

mysql_close( $conn );

?>

</body>
</html>
