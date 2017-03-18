WRMCB=function(e){var c=console;if(c&&c.log&&c.error){c.log('Error running batched script.');c.error(e);}}
;
try {
/* module-key = 'confluence.extra.masterdetail:master-details-resources', location = 'templates/extra/masterdetail/detailssummary.soy' */
// This file was automatically generated from detailssummary.soy.
// Please don't edit this file by hand.

/**
 * @fileoverview Templates in namespace Confluence.Templates.Macro.MasterDetail.
 */

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.Macro == 'undefined') { Confluence.Templates.Macro = {}; }
if (typeof Confluence.Templates.Macro.MasterDetail == 'undefined') { Confluence.Templates.Macro.MasterDetail = {}; }


Confluence.Templates.Macro.MasterDetail.detailsSummary = function(opt_data, opt_ignored) {
  var output = '<div class="table-wrap"><table class="aui metadata-summary-macro ' + soy.$$escapeHtml(opt_data.label) + '" data-cql="' + soy.$$escapeHtml(opt_data.cql) + '"' + ((opt_data.id) ? ' data-details-id="' + soy.$$escapeHtml(opt_data.id) + '" ' : '') + ((opt_data.macroHeadings) ? ' data-headings="' + soy.$$escapeHtml(opt_data.macroHeadings) + '" ' : '') + 'data-first-column-heading="' + soy.$$escapeHtml(opt_data.firstColumnHeading) + '" data-count-comments="' + soy.$$escapeHtml(opt_data.showCommentsCount) + '" data-count-likes="' + soy.$$escapeHtml(opt_data.showLikesCount) + '" data-total-pages="' + soy.$$escapeHtml(opt_data.totalPages) + '" data-page-size="' + soy.$$escapeHtml(opt_data.pageSize) + '" data-sort-by="' + soy.$$escapeHtml(opt_data.sortBy) + '" data-reverse-sort="' + soy.$$escapeHtml(opt_data.reverseSort) + '" data-blueprint-present="' + soy.$$escapeHtml(opt_data.blueprintPresent) + '"' + ((opt_data.analyticsKey) ? ' data-analytics-key="' + soy.$$escapeHtml(opt_data.analyticsKey) + '"' : '') + '>' + ((! opt_data.renderedHeadings) ? '<caption>' + soy.$$escapeHtml("Generating page properties report...") + '</caption>' : '') + '<thead>' + ((opt_data.renderedHeadings) ? Confluence.Templates.Macro.MasterDetail.detailsSummaryHeader(opt_data) : '') + '</thead><tbody>';
  if (opt_data.details) {
    var lineList55 = opt_data.details;
    var lineListLen55 = lineList55.length;
    if (lineListLen55 > 0) {
      for (var lineIndex55 = 0; lineIndex55 < lineListLen55; lineIndex55++) {
        var lineData55 = lineList55[lineIndex55];
        output += Confluence.Templates.Macro.MasterDetail.detailsSummaryLine({line: lineData55, showCommentsCount: opt_data.showCommentsCount, showLikesCount: opt_data.showLikesCount});
      }
    } else {
      output += Confluence.Templates.Macro.MasterDetail.detailsSummaryNoResults({headingCount: opt_data.renderedHeadings.length});
    }
  }
  output += '</tbody></table>' + ((opt_data.blueprintPresent) ? Confluence.Templates.Macro.MasterDetail.detailsSummaryBlueprintBlankExperience(opt_data) : '') + '</div>';
  return output;
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.detailsSummary.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.detailsSummary';
}


Confluence.Templates.Macro.MasterDetail.detailsSummaryNoResults = function(opt_data, opt_ignored) {
  return '<tr><td colspan="' + soy.$$escapeHtml(opt_data.headingCount + 1) + '">' + soy.$$escapeHtml("No content found.") + '</td></tr>';
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.detailsSummaryNoResults.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.detailsSummaryNoResults';
}


Confluence.Templates.Macro.MasterDetail.detailsSummaryHeader = function(opt_data, opt_ignored) {
  var output = '<tr><th>' + soy.$$escapeHtml(opt_data.firstColumnHeading) + '</th>';
  var headingList82 = opt_data.renderedHeadings;
  var headingListLen82 = headingList82.length;
  for (var headingIndex82 = 0; headingIndex82 < headingListLen82; headingIndex82++) {
    var headingData82 = headingList82[headingIndex82];
    output += '<th>' + soy.$$filterNoAutoescape(headingData82) + '</th>';
  }
  output += '</tr>';
  return output;
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.detailsSummaryHeader.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.detailsSummaryHeader';
}


Confluence.Templates.Macro.MasterDetail.detailsSummaryLine = function(opt_data, opt_ignored) {
  var output = '<tr><td class="title" data-content-id="' + soy.$$escapeHtml(opt_data.line.id) + '">' + Confluence.Templates.Macro.MasterDetail.contentLink2(opt_data) + '</td>';
  var lineDetailList96 = opt_data.line.details;
  var lineDetailListLen96 = lineDetailList96.length;
  for (var lineDetailIndex96 = 0; lineDetailIndex96 < lineDetailListLen96; lineDetailIndex96++) {
    var lineDetailData96 = lineDetailList96[lineDetailIndex96];
    output += '<td>' + soy.$$filterNoAutoescape(lineDetailData96 ? lineDetailData96 : '&nbsp;') + '</td>';
  }
  output += ((opt_data.showCommentsCount || opt_data.showLikesCount) ? '<td class="social">' + ((opt_data.showCommentsCount && opt_data.line.commentsCount > 0) ? '<span class="icon icon-comment">' + soy.$$escapeHtml("Comment:") + '</span> <span class="count">' + soy.$$escapeHtml(opt_data.line.commentsCount) + '</span>' : '') + ((opt_data.showLikesCount && opt_data.line.likesCount > 0) ? '<span class="icon icon-like">' + soy.$$escapeHtml("Like:") + '</span> <span class="count">' + soy.$$escapeHtml(opt_data.line.likesCount) + '</span>' : '') + '</td>' : '') + '</tr>';
  return output;
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.detailsSummaryLine.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.detailsSummaryLine';
}


Confluence.Templates.Macro.MasterDetail.contentLink2 = function(opt_data, opt_ignored) {
  return '<a href="' + soy.$$escapeHtml("/wiki") + soy.$$escapeHtml(opt_data.line.relativeLink) + '">' + soy.$$escapeHtml(opt_data.line.title) + '</a>' + ((opt_data.line.subTitle) ? '&gt; <a href="' + soy.$$escapeHtml("/wiki") + soy.$$escapeHtml(opt_data.line.subRelativeLink) + '">' + soy.$$escapeHtml(opt_data.line.subTitle) + '</a>' : '');
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.contentLink2.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.contentLink2';
}


Confluence.Templates.Macro.MasterDetail.detailsSummaryBlueprintBlankExperience = function(opt_data, opt_ignored) {
  return '<div class="blueprint-blank-experience"><div class="content"><h2>' + soy.$$escapeHtml(opt_data.blankTitle) + '</h2><p>' + soy.$$escapeHtml(opt_data.blankDescription) + '</p></div><p>' + soy.$$filterNoAutoescape(opt_data.createFromTemplateHtml) + '</p></div>';
};
if (goog.DEBUG) {
  Confluence.Templates.Macro.MasterDetail.detailsSummaryBlueprintBlankExperience.soyTemplateName = 'Confluence.Templates.Macro.MasterDetail.detailsSummaryBlueprintBlankExperience';
}

}catch(e){WRMCB(e)};
;
try {
/* module-key = 'confluence.extra.masterdetail:master-details-resources', location = 'com/atlassian/confluence/extra/masterdetail/js/metadata-summary-analytics.js' */
AJS.$(function(a){a(".metadata-summary-macro[data-analytics-key]").on("click",".title a",function(d){var b=a(d.delegateTarget).data("analytics-key");var c="metadata-summary-macro.content-click."+b;var e=a(this).parent().data("content-id");AJS.trigger("analytics",{name:c,data:{contentId:e}})})});
}catch(e){WRMCB(e)};
;
try {
/* module-key = 'confluence.extra.masterdetail:master-details-resources', location = 'com/atlassian/confluence/extra/masterdetail/js/metadata-summary.js' */
AJS.$(function(b){var a=function(c){if(c){return(""+c).replace(/[\[\]]/g,"")}return""};b(".metadata-summary-macro").each(function(){var k=b(this);var q=k.parent(),s=k.data("count-comments"),r=k.data("count-likes"),w=k.data("page-size"),x=k.data("total-pages"),c=k.data("headings"),f=k.data("first-column-heading"),o=a(k.data("sort-by")),m=a(k.data("reverse-sort")),u=k.data("blueprint-present"),j=a(k.data("spaces"));function i(y,A){var z=Confluence.Templates.Macro.MasterDetail.detailsSummaryLine({line:y,showCommentsCount:s,showLikesCount:r});A.append(z);k.trigger("update")}function n(A,z){var y=Confluence.Templates.Macro.MasterDetail.detailsSummaryHeader({firstColumnHeading:f,renderedHeadings:A});z.append(y)}function g(A,z){var y=Confluence.Templates.Macro.MasterDetail.detailsSummaryNoResults({headingCount:A.length});z.append(y)}var e={scope:q,pageSize:w,totalPages:x,path:"/rest/masterdetail/1.0/detailssummary/lines",data:{cql:k.data("cql"),spaceKey:AJS.Meta.get("space-key"),contentId:AJS.Meta.get("page-id"),detailsId:k.data("details-id"),headings:c,countComments:s,countLikes:r,sortBy:o,reverseSort:m},success:i};var v=k.find("caption");function h(z){if(!z.asyncRenderSafe){window.location.search+="&pagepropertiesreport.serverrender";return}v.hide();if(z.detailLines.length===0&&u){b(q).find("div.blueprint-blank-experience").show()}else{q.hide();n(z.renderedHeadings,k.find("thead"));var y=k.find("tbody");if(z.detailLines.length===0){g(z.renderedHeadings,y)}else{AJS.tablessortable.setTableSortable(k);_.each(z.detailLines,function(A){i(A,y)})}if(x>1){Confluence.UI.Components.Pagination.build(e)}q.slideDown()}}function l(y,A,z){v.text("Error while fetching page properties report data"+": "+z)}var t=b.extend({},{pageSize:w,pageIndex:0},e.data);var p=AJS.contextPath()+e.path;var d=k.children("thead").children("tr").length!==0;if(d){if(x>1){Confluence.UI.Components.Pagination.build(e)}}else{b.getJSON(p,t).done(h).fail(l)}})});
}catch(e){WRMCB(e)};