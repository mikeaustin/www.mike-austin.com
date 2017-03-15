<?php
/*
  $Id: footer.php,v 1.26 2003/02/10 22:30:54 hpdl Exp $

  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com

  Copyright (c) 2003 osCommerce

  Released under the GNU General Public License
*/

  require(DIR_WS_INCLUDES . 'counter.php');
?>
                     </td>
                    <td bgcolor="#FFFFFF"><?php echo tep_draw_separator('spacer.gif', '1', '1'); ?></td>
				</tr>
			</table>
          </td>
	</tr>
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" border="0" style="height:58px; xbackground:url(images/bot.gif)" class="footer">
				<tr>
					<!--<td><?php echo tep_image(DIR_WS_IMAGES.'q1.gif')?></td>-->
					<td style="width:199px"><?php echo tep_draw_separator('spacer.gif', '199', '1'); ?><br><br style="line-height:18px"><?php echo tep_image(DIR_WS_IMAGES.'p1.gif')?><br></td>		
					<td style="width:100%"><br style="line-height:11px"><span><a href="<?php echo tep_href_link('specials.php')?>"><?php echo BOX_HEADING_SPECIALS?></a></span> &nbsp; &nbsp;<span>|</span> &nbsp; &nbsp;<span><a href="<?php echo tep_href_link('advanced_search.php')?>"><?php echo BOX_SEARCH_ADVANCED_SEARCH?></a></span>  &nbsp; &nbsp;<span>|</span> &nbsp; &nbsp;<span><a href="<?php echo tep_href_link('reviews.php')?>"><?php echo BOX_HEADING_REVIEWS?></a></span>  &nbsp; &nbsp;<span>|</span> &nbsp; &nbsp;<span><? if (tep_session_is_registered('customer_id')) { 
?><a href="<?php echo tep_href_link('account.php')?>"><?php echo HEADER_TITLE_MY_ACCOUNT?></a><? } else 
{ ?><a href="<?php echo tep_href_link('create_account.php')?>"><?php echo HEADER_TITLE_CREATE_ACCOUNT?></a><? } 
?></span> &nbsp; &nbsp;<span>|</span> &nbsp; &nbsp;<span><? if (tep_session_is_registered('customer_id')) { 
?><a href="<?php echo tep_href_link('logoff.php')?>"><?php echo HEADER_TITLE_LOGOFF?></a><? } else 
{ ?><a href="<?php echo tep_href_link('login.php')?>"><?php echo HEADER_TITLE_LOGIN?></a><? } 
?></span><br style="line-height:1px;">
						  <br style="line-height:7px;"><?php echo FOOTER_TEXT_BODY?> &nbsp;| &nbsp;<b><a href="<?php echo tep_href_link('privacy.php')?>"><?php echo BOX_INFORMATION_PRIVACY?></a></b>
					</td>
					<!--<td><?php echo tep_image(DIR_WS_IMAGES.'q2.gif')?></td>-->
				</tr>
			</table>
         </td>
	</tr>
</table>

<?php
  if ($banner = tep_banner_exists('dynamic', '468x50')) {
?>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center"><?php /*  echo tep_display_banner('static', $banner);  */ ?></td>
  </tr>
</table>
<?php
  }
?>
