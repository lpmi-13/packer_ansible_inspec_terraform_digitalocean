## Validate an image file

packer validate -var-file=../packer/variables.json ../packer/server.json
(note: packer will check any other local paths relative to this directory, if you run the command from here)

## Build the image

packer build -var-file=../packer/variables.json ../packer/server.json
(note: packer will check any other local paths relative to this directory, if you run the command from here)
