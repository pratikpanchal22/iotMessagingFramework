<?php

// Credentials
$dbhost   ="localhost";
$username ="dummyUser";
$password ="dummyPassword";
$database ="messagingAppDb";

// Try and connect to the database
$connection = mysqli_connect($dbhost, $username, $password, $database);

//Test if connection took place
if(mysqli_connect_errno()) {
   die("Database connection failed: ".
        mysqli_connect_error() .
        " (" . mysqli_connect_errno() . ")"
   );
}
?>


<?php

//query to get the latest timestamp
$query = "select cStateTimeStamp from deviceList2 order by cStateTimeStamp desc limit 1;";
//echo "Query: ".$query."<br/>";
$result = mysqli_query($connection, $query);
// test for query error
if (!$result) {
   die("Database query failed.");
}

//echo "time(void): ".time(void)."<br/>";
$row = mysqli_fetch_assoc($result);
$message = $_GET["message"];
$destination = $_GET["destination"];

//echo strtotime($row["cStateTimeStamp"]);
//echo "<br/>";
//echo "Message: ".$message."<br/>"; 
//echo "Destination: ".$destination."<br/>"; 

// TWILIO SMS MESSAGING SERVICE - COSTS MONEY!!!
// $output = shell_exec("./messagingService.sh -p '$message' -d '$destination' -L");

// TWITTER SERVICE
$output = shell_exec("python twitterService.py '$message'");
//echo $output;

$date = date_create();
echo "End_of_php_execution_at_".date_timestamp_get($date)."_script_output_".$output;

mysqli_free_result($result);

?>


<?php
// Close the database connection
mysqli_close($connection);
?>