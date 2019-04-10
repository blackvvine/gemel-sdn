Gemel SDN
=========

This repository contains scrtipts for provisioning and managing resources on Gemel. The componenets are:

VNet
----
Convenient scripts for adding/removing hosts to/from virtual networks.


Set-up
------
Notes and scripting for setting up the SDN from scratch on GCP.


Provision
---------
Scripts used for instantiating new virtual machines and setting up OVS and connections on them


Getting Started
---------------

TODOs before using the scripts:

* [Add your public key as a project-wide metadata](https://cloud.google.com/compute/docs/storing-retrieving-metadata#projectwide) to the project so you can use the SSH and SCP command freely
* [Obtain a service account key JSON file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) from GCP (to be used with provision/gcp-login.sh)
* [Intall GCloud CLI](https://devopscube.com/setup-google-cloud-clisdk/) tool on your system.
* `apt install jq xmllint`
* `pip install beautifulsoup4`


