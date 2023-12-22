<?php
include 'connect.php';
$title = $_POST['title'];
$price = $_POST['price'];



// $userid = mysqli_insert_id($con);

$sql1 = mysqli_query($con, "INSERT INTO income(title,price)values('$title','$price')");


if ($sql1) {
    $my_array['result'] = "Success";
} else {
    $my_array['result'] = "Failed";
}
echo json_encode($my_array);


?>