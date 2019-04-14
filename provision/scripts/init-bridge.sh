#!/bin/bash

ovs-vsctl --may-exist add-br br0

ovs-vsctl --may-exist add-port br0 br0-int -- set interface br0-int type=internal




