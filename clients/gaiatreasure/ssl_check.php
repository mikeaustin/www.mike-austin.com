<?php
/*
  $Id: ssl_check.php,v 1.1 2003/03/10 23:32:20 hpdl Exp $

  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com

  Copyright (c) 2003 osCommerce

  Released under the GNU General Public License
*/

  require('includes/application_top.php');

  require(DIR_WS_LANGUAGES . $language . '/' . FILENAME_SSL_CHECK);

  $breadcrumb->add(NAVBAR_TITLE, tep_href_link(FILENAME_SSL_CHECK));
?>
<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<html <?php echo HTML_PARAMS; ?>>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<?php echo CHARSET; ?>">
<title><?php echo TITLE; ?></title>
<base href="<?php echo (($request_type == 'SSL') ? HTTPS_SERVER : HTTP_SERVER) . DIR_WS_CATALOG; ?>">
<link rel="stylesheet" type="text/css" href="stylesheet.css">
</head>
<body marginwidth="0" marginheight="0" topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0">
<!-- header //-->
<?php require(DIR_WS_INCLUDES . 'header.php'); ?>
<!-- header_eof //-->

<!-- body //-->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
  	<td class="col_left">
<!-- left_navigation //-->
<?php require(DIR_WS_INCLUDES . 'column_left.php'); ?>
<!-- left_navigation_eof //-->
	</td>
<!-- body_text //-->
    <td width="100%" class="col_center">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">

		<tr><td>
			
<? tep_draw_heading_top();?>
	
<? new contentBoxHeading_ProdNew($info_box_contents);?>

<? tep_draw_heading_top_1();?>
						
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="product">
      <tr>
        <td>						
						<table cellpadding="0" cellspacing="0" border="0" align="right" style="width:40%;" class="">
							<tr>
					<td><?php //new InfoBoxHeading(array(array('text' => BOX_INFORMATION_HEADING))) ; ?></td>
				  </tr>
							<tr><td class=""><br style="line-height:1px;"><br style="line-height:15px;"><?php new infoBox_78(array(array('text' => BOX_INFORMATION))); ?></td></tr>
						</table><br style="line-height:1px;"><br style="line-height:5px;"><?php echo TEXT_INFORMATION; ?></td>
      </tr>
      <tr>
        <td><?php echo tep_draw_separator('pixel_trans.gif', '100%', '10'); ?></td>
      </tr>
      <tr>
        <td align="right" class="main"><?php echo '<a href="' . tep_href_link(FILENAME_LOGIN) . '">' . tep_image_button('button_continue.gif', IMAGE_BUTTON_CONTINUE) . '</a>'; ?>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      </tr>
    </table>
					
<?php tep_draw_heading_bottom_1();?>					
		
<?php tep_draw_heading_bottom();?>
	
			</td></tr>
		</table>
	</form></td>

<!-- body_text_eof //-->
  	<td class="col_right">
<!-- right_navigation //-->
<?php require(DIR_WS_INCLUDES . 'column_right.php'); ?>
<!-- right_navigation_eof //-->
    </td>
  </tr>
</table>
<!-- body_eof //-->

<!-- footer //-->
<?php require(DIR_WS_INCLUDES . 'footer.php'); ?>
<!-- footer_eof //--></body>
</html>
<?php require(DIR_WS_INCLUDES . 'application_bottom.php'); ?>
