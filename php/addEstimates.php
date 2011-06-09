<?php
    $client = $_GET['client'];
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		</script>
		<script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="../js/jquery-dynamic-form.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				var mainDynamicForm = $("#phone").dynamicForm("#plus", "#minus", {
					limit:5
				});
			});
		</script>
	</head>
	<body>
	    Add Estimates to <strong> <?php echo $client; ?> </strong>
        <br><br>
		<form method="post" action="insertEstimates.php">
			Name:<br><input type="text" name="name" size="40"><br>
			Email:<br><input type="text" name="email" size="40"><br><br>
			<input type=hidden name="firm" value="<?php echo $firm; ?>" >
			<div id='phone'>
			    Number:<br><input type="text" name="number" size="40" /><br>
			    Mobile:<input type="radio" value="Mobile" name="type"        />
			    Office:<input class="checked" type="radio" value="Office" name="type" checked/>
			    Fax:   <input type="radio" value="Fax"    name="type"        />
			    <br><br>
			</div>
			<div><a id="minus" href="">[-]</a> <a id="plus" href="">[+]</a></div>
			<br>
            <input type="submit" />
		</form>
	</body>
</html>
