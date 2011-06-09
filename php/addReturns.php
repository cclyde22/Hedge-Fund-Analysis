<?php
    $fund = $_GET['fund'];
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		</script>
	</head>
	<body>
	    Add Returns to <strong> <?php echo $fund; ?> </strong>
        <br><br>
		<form method="post" action="insertReturns.php">
			<input type=hidden name="fund" value="<?php echo $fund; ?>" >
			<div id='returns'>
			    Monthly Return:<br><input type="text" name="monthly" size="40" /><br>
			    Date:<br><input type="text" name = "mdate" size="40"/><br>
			    Ytd Return:<br><input type="text" name="ytd" size = "40"/><br>
			    Date:<br><input type="text" name = "ydate" size="40"/><br>
			</div>
            <input type="submit" />
		</form>
	</body>
</html>
