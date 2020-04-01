# preseed
 
## Usage

* From your command line, run the following commands:

```
$ wget https://raw.githubusercontent.com/tomsdl/preseed/master/create-unattended-iso.sh
$ chmod +x create-unattended-iso.sh
$ sudo ./create-unattended-iso.sh
```
The script will keep a copy of the available iso in a work file for faster retrieval.
If you wish to rebuild the menu by retrieving available versions from ubuntu.com:
```
$ sudo ./create-unattended-iso.sh rebuild
```