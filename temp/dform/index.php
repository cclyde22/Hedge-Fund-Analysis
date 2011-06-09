<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>jQuery Dynamic Form Demo</title>
		</script>
		<script type="text/javascript" src="lib/jquery/jquery-1.4.2.js"></script>
		<script type="text/javascript" src="lib/jquery/jquery-ui-1.8.2.custom.min.js"></script>
		<script type="text/javascript" src="jquery-dynamic-form.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				var mainDynamicForm = $("#phone").dynamicForm("#plus", "#minus", {
					limit:5, 
					formPrefix:"mainForm",
				});
			});
		</script>
	</head>
	<body>
		<pre>
<?php
function formatForm($form, $level){
	foreach ($form as $key => $value) {
		if(is_array($value))
			formatForm($value, $level+1);
		else
			echo "$key : $value\n";
	}
}
formatForm($_POST, 0);
?>
		</pre>
		<form method="post" action="#" value="Post">

				Name:<br><input id="firstname" type="text" name="firstname" size="40"><br>
				Email:<br><input id="firstname" type="text" name="firstname" size="40"><br><br>
				
				<div id='phone'>
				    Number:<br><input type="text" name="number" size="40" /><br>
				    Mobile:<input type="radio" value="Mobile" name="type" />
				    Office:<input type="radio" value="Office" name="type" />
				    Fax:<input type="radio" value="Office" name="type" />
				    <br><br>
				</div>
				<div><a id="minus" href="">[-]</a> <a id="plus" href="">[+]</a></div>
				<br>
                <input type="submit" />
		</form>
	</body>
</html>
