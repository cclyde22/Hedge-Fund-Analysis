<?php
	//convert to necessary form
	if(!$con){
	die('could not connect: ' . mysqli_error($con));
	}
	mysqli_select_db($con, $hfdb);

    if($_POST['monthly'] == "" && $_POST['ytd'] == ""){
        echo "Go back and add a return this time!";
        exit();
    }

	/*write query to select fundID from fund name, so this value can be inserted into both
	$query = ...
	$result1 = $fundID*/
	
	/*use $fundID to write insert query for both returns
	//monthly returns
	$query = "insert into Return values('$fundID','{$_POST['monthly']}', '{$_POST['mdate']}')";
	//ytd returns
	$query = "insert into ReturnYtd values ('$fundID', '{$_POST['ytd']}', '{$_POST['ydate']}')";
	$result = mysqli_query($con, $query) or die (mysqli_error($con));*/
	
    echo "Added Returns<br>Close window, and be well";

	mysqli_close($con);
?>
