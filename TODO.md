TODO
====

* Configurable by backend
  * FileSystem backend
  * Vault backend

* Placeholder tasks
  * Placeholder::Create
    * Creates a placeholder secret
    * At a configured location
    * With a certain name
    * With certain contents
  * Placeholder::Delete
    * Deletes a placeholder secret
    * From the configured location
  * Placeholder::Check or ::Read?
    * Checks if a placeholder is readable
    * With certain contents
* Generate
  * Generates a secret
  * Based on a definition
  * Optionally uses a template
  * Stores using the backend
* Collect
  * Collect a secret from the terminal
  * Based on a definition
  * Use a template and the backend to store the collected secret
* GenerateAll
  * Takes a list of generator tasks
  * Executes each collector task
* CollectAll
  * Takes a list of collector tasks
  * Executes each collector task
* GenerateAll and CollectAll are the same, maybe task set instantiates one task
  type twice
* Provision
  * Generates and collects 
* Destroy
  * Takes a list of secrets paths
  * Uses the backend to delete each secret path
