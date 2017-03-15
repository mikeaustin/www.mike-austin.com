<?php
/*
  $Id: header.php,v 1.42 2003/06/10 18:20:38 hpdl Exp $

  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com

  Copyright (c) 2003 osCommerce

  Released under the GNU General Public License
*/

// check if the 'install' directory exists, and warn of its existence
  if (WARN_INSTALL_EXISTENCE == 'true') {
    if (file_exists(dirname($HTTP_SERVER_VARS['SCRIPT_FILENAME']) . '/install')) {
      $messageStack->add('header', WARNING_INSTALL_DIRECTORY_EXISTS, 'warning');
    }
  }

// check if the configure.php file is writeable
  if (WARN_CONFIG_WRITEABLE == 'true') {
    if ( (file_exists(dirname($HTTP_SERVER_VARS['SCRIPT_FILENAME']) . '/includes/configure.php')) && (is_writeable(dirname($HTTP_SERVER_VARS['SCRIPT_FILENAME']) . '/includes/configure.php')) ) {
      $messageStack->add('header', WARNING_CONFIG_FILE_WRITEABLE, 'warning');
    }
  }

// check if the session folder is writeable
  if (WARN_SESSION_DIRECTORY_NOT_WRITEABLE == 'true') {
    if (STORE_SESSIONS == '') {
      if (!is_dir(tep_session_save_path())) {
        $messageStack->add('header', WARNING_SESSION_DIRECTORY_NON_EXISTENT, 'warning');
      } elseif (!is_writeable(tep_session_save_path())) {
        $messageStack->add('header', WARNING_SESSION_DIRECTORY_NOT_WRITEABLE, 'warning');
      }
    }
  }

// check session.auto_start is disabled
  if ( (function_exists('ini_get')) && (WARN_SESSION_AUTO_START == 'true') ) {
    if (ini_get('session.auto_start') == '1') {
      $messageStack->add('header', WARNING_SESSION_AUTO_START, 'warning');
    }
  }

  if ( (WARN_DOWNLOAD_DIRECTORY_NOT_READABLE == 'true') && (DOWNLOAD_ENABLED == 'true') ) {
    if (!is_dir(DIR_FS_DOWNLOAD)) {
      $messageStack->add('header', WARNING_DOWNLOAD_DIRECTORY_NON_EXISTENT, 'warning');
    }
  }

  if ($messageStack->size('header') > 0) {
    echo $messageStack->output('header');
  }
?>
<!-- start -->
<table cellpadding="0" cellspacing="0" border="0" style="width:697px; background:#FFFFFF" align="center"> 
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" border="0" style="xheight:344px; width:697px" class="header" align="center">
				<tr>
					<td align="center">
                    	 <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td><a href="<?php echo tep_href_link('index.php')?>"><?php echo tep_image(DIR_WS_IMAGES.'logo.gif')?></a></td>
                                <td style="width:183px; text-align: left; vertical-align: bottom; padding-bottom: 24px;">
                                     <?php echo tep_image(DIR_WS_IMAGES.'z1.gif','','','',' class="vam"')?> <span style="position: relative; top: 1px;"><?php echo BOX_HEADING_SHOPPING_CART?></span>
                                     <a href="<?php echo tep_href_link('shopping_cart.php')?>" style="position: relative; top: 1px;"><?php echo $cart->count_contents()?> <?php echo BOX_SHOPPING_CART_EMPTY?></a>
                                </td>
                                <td style="width:120px; text-align: right; vertical-align: bottom; padding-bottom: 23px;">
                                        <?php
                                             if (!isset($lng) || (isset($lng) && !is_object($lng))) {
                                                include(DIR_WS_CLASSES . 'language.php');
                                                $lng = new language;
                                             }
                                             $languages_string = '';
                                             reset($lng->catalog_languages);
                                             while (list($key, $value) = each($lng->catalog_languages)) {
                                                $languages_string .= '</a>&nbsp;&nbsp;' . '<a href="' . tep_href_link(basename($PHP_SELF), tep_get_all_get_params(array('language', 'currency')) .
                                                 'language=' . $key, $request_type) . '">' . tep_image(DIR_WS_LANGUAGES . $value['directory'] . '/images/' . $value['image'], $value['name']);
                                             }
                                             echo $languages_string;
                                        ?>
                                </td>
                            </tr>
                        </table> 
                         <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td align="center"><!--
                                    --><a href="<?php echo tep_href_link('index.php')?>"><span style="position: absolute; width: 136px; text-align: center; line-height: 44px; color: #7f4d57; cursor: pointer;"><?php echo HEADER_TITLE_HOME_PAGE ?></span>
                                    <img src="images/m1.gif" border="0" alt="" width="136" height="44"></a><!--
                                    --><a href="<?php echo tep_href_link('products_new.php')?>"><?php echo tep_image_button('m2.gif')?></a><!--
                                    --><a href="<?php echo tep_href_link('specials.php')?>"><?php echo tep_image_button('m3.gif')?></a><!--
                                    --><a href="<?php echo tep_href_link('account.php')?>"><?php echo tep_image_button('m4.gif')?></a><!--
                                    --><a href="<?php echo tep_href_link('contact_us.php')?>"><?php echo tep_image_button('m5.gif')?></a><!--
                                    --><br><br style="line-height:4px">
                                </td>
                            </tr>
                        </table>
                        <?php if (substr(basename($PHP_SELF), 0, 5) == 'index') { ?>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                    	<table cellpadding="0" cellspacing="0" border="0">
                                        	<tr>
                                            	<td><a href="<?php echo tep_href_link('specials.php')?>"><?php echo tep_image(DIR_WS_IMAGES.'p.jpg')?></a></td>
                                                <td><a href="<?php echo tep_href_link('index.php?cPath=3')?>"><?php echo tep_image(DIR_WS_IMAGES.'bann1.jpg')?></a><br>
                                                    <a href="<?php echo tep_href_link('index.php?cPath=2')?>"><?php echo tep_image(DIR_WS_IMAGES.'bann2.jpg')?></a><br>
                                                    <a href="<?php echo tep_href_link('index.php?cPath=5')?>"><?php echo tep_image(DIR_WS_IMAGES.'bann3.jpg')?></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        <?php } ?>
                     </td>
				</tr>
			</table>
         </td>
	</tr>
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" border="0" style="height:500px; background:url(images/1_bg.gif) repeat-x top ">
				<tr>
					<td bgcolor="#FFFFFF"><?php echo tep_draw_separator('spacer.gif', '1', '1'); ?></td>
					<td class="col_left">
<!-- end -->
<?php
  if (isset($HTTP_GET_VARS['error_message']) && tep_not_null($HTTP_GET_VARS['error_message'])) {
?>
<table border="0" width="100%" cellspacing="0" cellpadding="2">
  <tr class="headerError">
    <td class="headerError"><?php echo htmlspecialchars(stripslashes(urldecode($HTTP_GET_VARS['error_message']))); ?></td>
  </tr>
</table>
<?php
  }

  if (isset($HTTP_GET_VARS['info_message']) && tep_not_null($HTTP_GET_VARS['info_message'])) {
?>
<table border="0" width="100%" cellspacing="0" cellpadding="2">
  <tr class="headerInfo">
    <td class="headerInfo"><?php echo htmlspecialchars(stripslashes(urldecode($HTTP_GET_VARS['info_message']))); ?></td>
  </tr>
</table>
<?php
  }
?>
<!-- start -->


<!-- end -->

<?php 
define(MAX_DESCR_1,'18');
define(MAX_DESCR_BESTS,'19');
define(MAX_DESCR_REVIEWS,'59');
?>
