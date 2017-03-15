<?php
/*
  $Id: popup_search_help.php,v 1.4 2003/06/05 23:26:23 hpdl Exp $

  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com

  Copyright (c) 2003 osCommerce

  Released under the GNU General Public License
*/

  require('includes/application_top.php');

  $navigation->remove_current_page();

  require(DIR_WS_LANGUAGES . $language . '/' . FILENAME_ADVANCED_SEARCH);
?>
<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<html <?php echo HTML_PARAMS; ?>>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<?php echo CHARSET; ?>">
<base href="<?php echo (($request_type == 'SSL') ? HTTPS_SERVER : HTTP_SERVER) . DIR_WS_CATALOG; ?>">
<title><?php echo TITLE; ?></title>
<link rel="stylesheet" type="text/css" href="stylesheet.css">
</head>
<body>
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%; background:#ffffff">
  <tr>
    <td  style="width:100%; height:100%; vertical-align:middle">
		<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:342px; background:url(images/5_bg.gif)">		
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0" class="product">
                        <tr>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'logo1.gif')?></td>
                            <td style="width:88px"><br style="line-height:20px"><a href="#" onClick="window.close()"><?php echo TEXT_CLOSE_WINDOW; ?></a><br></td>
                        </tr>
                    </table> 
                     <table cellpadding="0" cellspacing="0" border="0" class="cont_heading_table">
                        <tr>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'cont_corn_tl_3.gif')?></td>
                            <td style="width:100%" class="cont_heading_td"><?php echo HEADING_SEARCH_HELP?></td>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'cont_corn_tr_3.gif')?></td>
                        </tr>
                    </table>
                     <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="line_x"><?php echo tep_draw_separator('spacer.gif', '1', '1'); ?></td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="cont_body_tall_l"><?php echo tep_draw_separator('spacer.gif', '1', '1'); ?></td>
                         	<td style="width:100%; border:1px solid #FFFFFF; border-width:16px 5px 0 15px" class="product"><?php echo TEXT_SEARCH_HELP?></td>
                            <td class="cont_body_tall_r"><?php echo tep_draw_separator('spacer.gif', '1', '1'); ?></td>
                        </tr>
                    </table> 
                     <table cellpadding="0" cellspacing="0" border="0" class="cont_heading_table">
                        <tr>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'cont_corn_bl.gif')?></td>
                            <td style="width:100%; background:url(images/cont_corn_bc.gif)"></td>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'cont_corn_br.gif')?></td>
                        </tr>
                    </table> <?php echo tep_draw_separator('spacer.gif', '1', '6'); ?>
                    <table cellpadding="0" cellspacing="0" border="0" style="height:68px; background:url(images/bot.gif) repeat-x top" class="footer">
                        <tr>
                            <td><?php echo tep_image(DIR_WS_IMAGES.'q1.gif')?></td>			
                            <td style="width:100%">
                                <br style="line-height:16px"><?php echo FOOTER_TEXT_BODY?></td>
                            
                            <td><?php echo tep_image(DIR_WS_IMAGES.'q2.gif')?></td>
                        </tr>
                    </table>
                </td>
			</tr>
		</table>	
	</td>
  </tr>
</table>	

</body>
</html>
<?php require('includes/application_bottom.php'); ?>
