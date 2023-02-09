TODO
====

* Storage::FileSystem
  * Add support for removing by 'directory'
  * Add base_path for relative paths, defaulting to Dir.cwd
* Storage::InMemory
  * Add base_path for relative paths, defaulting to /

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

* Work out how to properly test random generators
  * Ideally we would assert that all characters in the character set are
    present in the results. However, due to the randomness, it's possible
    that's sometimes not the case. There's no good way to assert that all
    characters are used, without making some assertions about the
    statistical distribution of characters which seems overkill.
