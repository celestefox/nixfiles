{ config, ... }:

{
  /*
    This file is where TF config common to all targets go.

    SETUP:
    Please create a submodule at /depot/tf.
    Make it still contain the content already provided.
    Make it private and gcrypted if you would like.
  */

  commandPrefix = "pass";
  folderPrefix = "secrets";
  folderDivider = "/";
}
