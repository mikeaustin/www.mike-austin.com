<?php
$fileName = $_REQUEST['filename'];
$filePath = '/home/users/web/b781/ipw.mike-aus/public_html/other/music/4FY457DEWE434P5/';

/* In kB/s */
$speed = 10;

if (!$file = fopen( $filePath . $fileName, 'r' )) {
  exit;
}

header( "Cache-control: private" );
header( 'Content-Description: File Transfer' ); 
header( 'Content-Type: application/force-download' ); 
header( 'Content-Length: ' . filesize( $filePath . $fileName ) ); 
header( 'Content-Disposition: attachment; filename="' . $fileName . '"' );

while (!feof( $file )) {
  echo fread( $file, $speed * 1024 * 8 );
  flush();
  sleep( 1 );
}

fclose( $file );
?>