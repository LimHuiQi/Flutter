<?php

// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Get the user ID from the request body
    $userId = $_POST['userid'];

    // Include the database connection file
    include_once("dbconnect.php");

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Prepare and bind the statement to fetch the user's balance
    $stmt = $conn->prepare("SELECT user_balance FROM tbl_users WHERE user_id = ?");
    $stmt->bind_param("i", $userId);

    // Execute the statement
    if ($stmt->execute()) {
        // Bind the result to a variable
        $stmt->bind_result($userBalance);

        // Fetch the result
        $stmt->fetch();

        // Return the balance in JSON format
        $response = array("status" => "success", "balance" => $userBalance);
        echo json_encode($response);
    } else {
        $response = array("status" => "error", "message" => "Failed to fetch wallet balance: " . mysqli_error($conn));
        echo json_encode($response);
    }

    // Close the statement and database connection
    $stmt->close();
    $conn->close();
} else {
    // Invalid request method
    $response = array("status" => "error", "message" => "Invalid request method.");
    echo json_encode($response);
}
?>
