<?php
	
	// Central HTTP API controller to control the document store access
	
	// Adding the PDO wrapper class
	require_once("class.db.php");
	require_once("config.php");

	// Get the requested URI to process
	$request_uri = $_SERVER['REQUEST_URI'];
	
	//Strip the base uri of the request
	$base_uri = $_SERVER['SCRIPT_NAME'];
	$base_uri = str_replace("index.php", "", $base_uri);
	$request_uri = str_replace($base_uri, "", $request_uri); 
	// echo $request_uri;
	
	// Identifying the type of Request made
	$request_method = $_SERVER['REQUEST_METHOD'];
	
	switch($request_method) {
		// Used generally to fetch the results or for querying
		case "GET":
		case "QUERY":
			$request_params = explode("/",$request_uri);
			$request_params_count = count($request_params);

			// Hoping most of the 
			$request_id = $request_params[$request_params_count - 1];
			
			// Remove the Request ID of the $request_params
			unset($request_params[$request_params_count - 1]);
			
			// Build the Request URL 
			$request_url = implode("/", $request_params);
			
			// Building the query to fetch the data from the server
			$query_result = $db->run("SELECT d.url, k.name, a.value, a.idattributes, a.parent_id FROM `document` d, `attributes` a, `keys` k where d.url = :url and a.doc_id = d.iddocument and k.idkeys = a.key_id and (select value from attributes where key_id = d.key_id and value = :doc_id) order by k.name", array(":url" => $request_url, ":doc_id" => $request_id));
			
			echo (buildJSONObject($query_result));
			break;
			
		// Used to add new content
		case "POST":
			// Get the document to be added to the datastore
			if(isset($_POST['doc'])) {
				$document = $_POST['doc'];
			} else {
				emit(array("status" => false, "message" => "No valid document was posted with the request.", "error_code" => 1));
			}
			break;
	}