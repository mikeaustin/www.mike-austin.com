<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
  <style type="text/css">
    *		{ margin: 0; padding: 0; font: 12px/1.5em sans-serif; color: #404040; }
    h1		{ font: bold 20px/1em sans-serif; }
    ul		{ list-style: none; }
    a		{ text-decoration: none; }
    #header	{ position: relative; background: #5986b3; }
    #navbar	{ position: relative; height: 30px; padding: 5px 5px 0 5px; }
    x#navbar li	{ padding: 1px; }
    #navbar a	{ display: block; font: 16px/1em Arial, sans-serif; font-weight: bold; height: 30px;
		  color: #ffffff; line-height: 30px; padding: 0 7px; }
    #navbar
     a:hover	{ background: #ffffff; color: #5986b3; }
    #body	{ padding: 12px; }

    .before	{ float: left; display: inline; }
  </style>
</head>
<body>
  <div id="header">
    <div style="position: absolute; top: 55%; right: 0%; bottom: 0%; left: 0%; background: black; opacity: 0.2;"></div>
    <ul id="navbar">
      <li class="before"><a href="#">Updates</a></li>
      <li class="before"><a href="#">All Files</a></li>
      <li class="before"><a href="#">Collaborators</a></li>
      <li class="before"><a href="#">Profile</a></li>
      <li class="before"><a href="#">OpenBox</a></li>
      <li>&nbsp;</li>
    </ul>
  </div>
  <div id="body">
    <h1>All files and folders</h1>
  </div>

  <!--
  <?php
    echo date("Y-m-d") . "<br/>";

    $hello = "Hello";

    echo $hello . " World" . "<br/>";
    echo strlen($hello) . "<br/>";

    if ($hello == "Hello") {
      echo "Yes";
    } else {
      echo "No";
    }

    echo "\n";

    function testArrays($loops) {
      $array = array(1, 2, 3);
      $map = array("a" => 1, "b" => 2);

      echo $array[0] + $map['a'] . "<br/>";

      foreach ($map as $i) {
        echo $i . " ";
      }

      return true;
    }

    testArrays(10);
  ?>

  <form action="index.php" method="post">
    Name: <input type="text" name="name" />
    Age: <input type="text" name="age" />
    <input type="submit" />
  </form>

  <?php echo $_POST["name"]; ?><br/>
  <?php echo $_POST["age"]; ?><br/>
  -->
</body>
</html>
