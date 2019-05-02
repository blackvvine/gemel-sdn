#!/bin/bash


# create two VNs

curl --user "admin":"admin" -H "Content-type: application/json" -X POST http://localhost:8181/restconf/operations/vtn:update-vtn -d "{\"input\":{\"tenant-name\":\"vtn1\"}}"

# curl --user "admin":"admin" -H "Content-type: application/json" -X POST http://localhost:8181/restconf/operations/vtn:update-vtn -d "{\"input\":{\"tenant-name\":\"vtn2\"}}"

# create a v-Bridge inside each VN

curl --user "admin":"admin" -H "Content-type: application/json" -X POST http://localhost:8181/restconf/operations/vtn-vbridge:update-vbridge -d '{"input":{"tenant-name":"vtn1", "bridge-name":"vbr1"}}'

# curl --user "admin":"admin" -H "Content-type: application/json" -X POST http://localhost:8181/restconf/operations/vtn-vbridge:update-vbridge -d '{"input":{"tenant-name":"vtn2", "bridge-name":"vbr2"}}'


# ============================================= #

# create an interface into the bridge

curl --user "admin":"admin" -H "Content-type: application/json" -X POST http://localhost:8181/restconf/operations/vtn-vinterface:update-vinterface -d '{"input":{"tenant-name":"vtn1", "bridge-name":"vbr1", "interface-name":"vn1i1"}}'



