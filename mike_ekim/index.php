<?php
foreach ($_POST as $key => $value) {
    echo "$key = $value<br/>\n";
}
?>

<fb:query q="select movies from user where uid=584050330"/>

<fb:dashboard>
  <fb:action href="?id=1234567">My Book Reviews</fb:action>
  <fb:action href="new.php">Write a New Review</fb:action>
  <fb:help href="help.php" title="Need help">Help</fb:help>
  <fb:create-button href="new.php">Write a New Review</fb:create-button>
</fb:dashboard>

<fb:wall>
  <fb:wallpost uid="1000550" t="1180070566">
    Whoa, I wrote on a wall!
    <fb:wallpost-action href="http://www.mike-austin.com/index.html">
      Reply
    </fb:wallpost-action>
  </fb:wallpost>
</fb:wall>

<fb:friend-selector/>

<fb:editor action="?do-it" labelwidth="100">
  <fb:editor-text label="Title" name="title" value=""/>
  <fb:editor-text label="Author" name="author" value=""/>
  <fb:editor-custom label="Status">
    <select name="state">
      <option value="0" selected>have read</option>
      <option value="1">am reading</option>
      <option value="2">want to read</option>
    </select>
  </fb:editor-custom>
  <fb:editor-textarea label="Comment" name="comment"/>
  <fb:editor-buttonset>
    <fb:editor-button value="Add"/>
    <fb:editor-button value="Recommend"/>
    <fb:editor-cancel />
  </fb:editor-buttonset>
</fb:editor>

<div id="preview"></div>

<input type="submit"
  clickrewriteurl="http://www.mike-austin.com/index.html"
  clickrewriteid="preview" value=" meta preview "/>
