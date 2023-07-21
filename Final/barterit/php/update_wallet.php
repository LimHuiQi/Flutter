<?php
include_once("dbconnect.php");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set the timezone to Malaysia
date_default_timezone_set('Asia/Kuala_Lumpur');

// Get the user ID, updated wallet balance, and current timestamp from the request
$userId = $_POST['userid'];
$updatedBalance = $_POST['balance'];
$currentTimestamp = time(); // Current Unix timestamp

// Convert current timestamp to MySQL datetime format
$currentDate = date("Y-m-d H:i:s", $currentTimestamp);

$withdrawAmount = $_POST['withdrawAmount'];

// Calculate the new balance after withdrawal
$newBalance = $updatedBalance - $withdrawAmount;

// Prepare and bind the statement
$stmt = $conn->prepare("UPDATE tbl_users SET user_balance = ?, user_dateupdate = ? WHERE user_id = ?");
$stmt->bind_param("dsi", $newBalance, $currentDate, $userId);

// Execute the statement
if ($stmt->execute()) {
    $response = array("status" => "success", "message" => "Wallet balance updated successfully.");
} else {
    $response = array("status" => "error", "message" => "Failed to update wallet balance: " . mysqli_error($conn));
}

// Close the statement and database connection
$stmt->close();
$conn->close();

// Send the response as JSON
header('Content-Type: application/json');
echo json_encode($response);
?>
