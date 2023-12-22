<?php
include 'connect.php';
$sql = mysqli_query($con,"SELECT * FROM `income` ORDER BY `income`.`id` DESC");
$list = array();
if ($sql->num_rows > 0) {
    while ($rows = mysqli_fetch_assoc($sql)) {


        $my_array['result'] = "Success";
        $my_array['title'] =$rows['title'];
        $my_array['pricee'] =$rows['price'];
       
        


        array_push($list, $my_array);

    }
} else {

    $my_array['result'] = "Failed";
    array_push($list, $my_array);

}

echo json_encode($list);
?>