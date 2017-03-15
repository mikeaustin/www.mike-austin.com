// <SCRIPT SRC="xxx.js">

function openHelp( task, type ) {
  opener.document.forms[0].navigationbar_task.value = task;
  opener.document.forms[0].navigationbar_type.value = type;
  opener.document.forms[0].submit();
  opener.focus();
}
