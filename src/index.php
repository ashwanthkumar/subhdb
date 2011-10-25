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
			$query_result = $db->run("SELECT d.url, k.name, a.value, a.idattributes, a.parent_id FROM `document` d, `attributes` a, `keys` k WHERE d.url = :url AND a.doc_id = d.iddocument AND k.idkeys = a.key_id AND (SELECT value FROM `attributes` WHERE key_id = d.key_id AND value = :doc_id) ORDER BY d.key_id", array(":url" => $request_url, ":doc_id" => $request_id));
			
			header("Content-type: application/json");
			echo buildJSONObject($query_result);
			break;
			
		// Used to add new content
		case "POST":
			// Get the document to be added to the datastore
			if(isset($_POST['doc'])) {
				$document = $_POST['doc'];
				
				$jsonObject = json_decode($document);
				$vars = get_object_vars($jsonObject);
				
				// Set the documentId Key
				$documentId = null;
				$documentIdValue = null;

				// Checking if the ID attribute exist in the keys table
				$k = $db->select("`keys`", "name = :name", array(":name" => "id"));
				if(count($k) > 0) {
					// Get the PK of the "id" Key
					$documentId = $k[0]["idkeys"];
				} else {
					// Key does not exist, add it as a reference and get its PK
					$db->insert("`keys`", array("name" => "id"));
					$documentId = $db->lastInsertId();
				}
				
				// Creating the document
				$db->insert("document", array("url" => $request_uri, "key_id" => $documentId));
				$documentPK = $db->lastInsertId();
				
				// Helps recursively add all the attributes to the datastore for the given document
				addKeysToIndex($vars, $documentPK, -1);
				
				// Adding the ID value attribute to the document
				if(isset($vars["id"])) {
					// If the id value is present it would be added by now in the addKeysToIndex() so, we're going to just ignore and hope the function completed successfully. Krshna!
					$documentIdValue = $vars["id"];
				} else {
					$documentIdValue = $documentPK;
					$db->insert("attributes", array("value" => $documentIdValue, "key_id" => $documentId, "doc_id" => $documentPK));
				}
				
				emit(array("status" => true, "message" => "Document added with ID " . $documentIdValue, "doc_id" => $documentIdValue));
			} else {
				emit(array("status" => false, "message" => "No valid document was posted with the request.", "error_code" => 1));
			}
			break;
	}
